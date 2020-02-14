
require 'pocketsphinx-ruby'
require 'mqtt/sub_handler'

$mqtt = MQTT::SubHandler.new("mqtt://Xasin:ChocolateThings@192.168.6.111")

$group_scoring = {
	'default' => 1,
}

### GENERATE MEME LIST
memeList = `find ./`.split("\n");
$memeHash  = {}
$groupList = [];

memeList.each do |e|
	rMatch = /^\.\/sounds\/(?<groups>(?:[a-z_]+[\/-])*)(?<effect>[a-z_]+)(?<variation>-\d+)?\.(?:ogg|mp3|wav)/.match e;
	next unless rMatch;

	effect = rMatch[:effect].gsub('_', ' ');
	groups = rMatch[:groups].gsub('_', ' ').gsub('-','/').split('/');

	groups = ["default"] if groups.empty?

	$memeHash[effect] ||= {};
	$memeHash[effect][e] = groups;
	$groupList += groups;
	$groupList.uniq!
end

puts "Meme Hash is: #{$memeHash}"

File.write("Control.JSGF", File.read("Control.JSGF.Template") % {
	memes: 	$memeHash.keys.join(" | "),
	groups: 	$groupList.join(" | ")
});

pocket_cfg = Pocketsphinx::Configuration::Grammar.new("Control.JSGF");
$pocket_reader = Pocketsphinx::AudioFileSpeechRecognizer.new(pocket_cfg);
$pocket_reader.recognize('./Primer.raw');

rec  = IO.popen("arecord -r 32000 -f S16_LE -R 0 --period-size 512",
	:external_encoding=>"ASCII-8BIT");
rec.binmode

# -Dplughw:CARD=Loopback,DEV=1

play = IO.popen("aplay -r 32000 -f S16_LE -R 0 --buffer-size 2048 -", "a",
	:external_encoding=>"ASCII-8BIT");
play.binmode

read_bfr_string = "";
current_sample_buffer = [];

out_sample_buffer = [];
echo_buffer = [];

6000.times do
	echo_buffer.push 0;
end;

$fb_delay = 0;
$samp_increase = 0;

def set_fb_frequency(freq)
  $fb_delay = 32000 / freq;
  $samp_increase = 40 * 2 * Math::PI / 32000;
end

$outFile = nil;
def begin_recording()
	$outFile = File.open("/tmp/Memeinator.raw", "wb");
end

$active_threads = [];
def play(name)
	program, groups = name.split(" from ");
	groups ||= "";
	groups = groups.split(" and ");

	local_score = $group_scoring.merge(groups.map { |g| [g, 2] }.to_h);

	return unless (effect = $memeHash[program]);

	tgt_sounds = nil;
	best_score = -10;

	effect.each do |file, groups|
		score = groups.sum { |g| local_score[g] || 0 }

		if(score > best_score)
			tgt_sounds = [file]
			best_score = score;
		elsif(score == best_score)
			tgt_sounds << file;
		end
	end

	Thread.new do
		fork_pid = fork {
			exec("play --volume 0.3 #{tgt_sounds.sample}");
		}
		$active_threads << fork_pid;
		Process.waitpid(fork_pid);
		$active_threads.delete fork_pid
	end
end

play("hello")

def end_recording()
	myFile = $outFile;
	$outFile = nil;
	sleep 0.01;

	myFile.close();
	$pocket_reader.recognize('/tmp/Memeinator.raw') do |t|
		puts "\n\n RECOGNIZED: #{t}"

		case t
		when /select groups (.+)/
			$group_scoring = $1.split(" and ").map { |g| [g, 1] }.to_h
		when /kill sounds/
			$active_threads.each { |pid| Process.kill("QUIT", pid) };
		else
			play(t);
		end
	end
end

$samp_time = 0;
set_fb_frequency(160)


$mqtt.subscribe_to "Test/VCTRL" do |data|
	if(data == "1" && $outFile.nil?)
		begin_recording()
	elsif data == "0" && $outFile
		end_recording()
	end
end

Thread.new do
	loop do
		current_sample_buffer = rec.read(512, read_bfr_string).unpack("s<*")

		out_sample_buffer = [];

		current_sample_buffer.each do |os|
			$samp_time += $samp_increase;

			os *= 0.01 if $outFile

			os *= 0.8 + 0.2*Math.sin($samp_time);

			s = os + 0.7 * (echo_buffer[-$fb_delay] + echo_buffer[-$fb_delay*2-1] + echo_buffer[-$fb_delay*2] + echo_buffer[0]*0.2)/3;

			echo_buffer.shift
			echo_buffer.push s

			out_sample_buffer.push os * 0.6 + 0.4*s;
		end

		$outFile&.write current_sample_buffer.each_slice(2).map(&:first).pack("s<*");

		play.write out_sample_buffer.pack("s<*");
	end
end

$mqtt.lock_and_listen
