
require 'pocketsphinx-ruby'
require 'mqtt/sub_handler'

require_relative '../AnimationControl/lib/tef/ProgramSelection/SoundCollection.rb'

$mqtt = MQTT::SubHandler.new("mqtt://localhost")

### GENERATE MEME LIST
$program_selector = TEF::ProgramSelection::Selector.new()
$soundmap = TEF::ProgramSelection::SoundCollection.new($program_selector);

$program_selector.group_weights = {
	"announcer" => 2,
}

File.write("Control.JSGF", File.read("Control.JSGF.Template") % {
	memes: 	$program_selector.all_titles.join(" | "),
	groups: 	$program_selector.all_groups.join(" | ")
});

pocket_cfg = Pocketsphinx::Configuration::Grammar.new("Control.JSGF");
pocket_cfg['logfn'] = "/dev/null"
$pocket_reader = Pocketsphinx::AudioFileSpeechRecognizer.new(pocket_cfg);
$pocket_reader.recognize('./Primer.raw');

def play(name)
	return unless effect = $program_selector.fetch_string(name)
	$soundmap.play effect
end

10.times do
	play("hello")
	sleep 1.7
end

rec  = IO.popen("arecord -r 32000 -f S16_LE -R 0 --period-size 512",
	:external_encoding=>"ASCII-8BIT");
rec.binmode
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

			os *= 0.75 + 0.25*Math.sin($samp_time);

			s = os + 0.8 * (echo_buffer[-$fb_delay] + echo_buffer[-$fb_delay*2-1] + echo_buffer[-$fb_delay*2] + echo_buffer[0]*0.2)/3;

			echo_buffer.shift
			echo_buffer.push s

			out_sample_buffer.push os * 0.7 + 0.3*s;
		end

		$outFile&.write current_sample_buffer.each_slice(2).map(&:first).pack("s<*");

		play.write out_sample_buffer.pack("s<*");
	end
end

$mqtt.lock_and_listen
