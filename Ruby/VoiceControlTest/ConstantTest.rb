
require 'tef/furcoms.rb'
require 'tef/animation.rb'

require 'mqtt/sub_handler'

$mqtt = MQTT::SubHandler.new('localhost');

$direct_port = TEF::FurComs::SerialToMQTT.new('/dev/ttyACM0', $mqtt);
$port = $direct_port; #TEF::FurComs::MQTT.new($mqtt, 'FurComs/ttyACM0/');

$animation_core = TEF::Animation::Handler.new($port)
$parameters = TEF::ParameterStack::Stack.new();

$sequencePlayer = TEF::Sequencing::Player.new();
$sequencePlayer.after_exec {
	$parameters.process_changes
	$animation_core.update_tick
}

load 'ParameterInit.rb'

$program_selector = TEF::ProgramSelection::Selector.new()

$soundmap = TEF::ProgramSelection::SoundCollection.new($program_selector);
$sheetmap = TEF::ProgramSelection::SequenceCollection.new($program_selector, $sequencePlayer)

Dir.glob('sheets/**/*.rb').each { |fn| load fn }

$parameters.process_changes
$animation_core.update_tick

def play(name)
	return unless effect = $program_selector.fetch_string(name)
	$sheetmap.play effect
end

File.write("Control.JSGF", File.read("Control.JSGF.Template") % {
	memes: 	$program_selector.all_titles.join(" | "),
	groups: 	$program_selector.all_groups.join(" | ")
});

$pocketsphinx_pid = fork do
	exec('ruby', 'SubprocessRecognition.rb');
end
at_exit do
	Process.kill("QUIT", $pocketsphinx_pid);
	Process.wait($pocketsphinx_pid);
end

Thread.new() do
	sleep 3
	play("hello from turret")
end

$port.on_message "BTN" do |data|
	btn_state = (data != "UP");

	if btn_state
		begin_recording()
		puts "Recognizing"
	else
		end_recording()
		puts "Playback!"
	end
end

$outFile = nil;
def begin_recording()
	$outFile = File.open("/tmp/Memeinator.raw", "wb");
end

def end_recording()
	return unless $outFile

	myFile = $outFile;
	$outFile = nil;
	sleep 0.01;

	myFile.close();

	$mqtt.publish_to 'Pocketsphinx/Request', '1';
end

$mqtt.subscribe_to 'Pocketsphinx/Result' do |result|
	if m = /computer ambiance level (.*)/.match(result)
		$parameters['Ambiance/Level'] = m[1];
	else
		play result
	end
end

rec  = IO.popen("arecord -r 16000 -f S16_LE -R 0 --period-size 512",
	:external_encoding=>"ASCII-8BIT");
rec.binmode
play = IO.popen("aplay -r 16000 -f S16_LE -R 0 --buffer-size 2048 -", "a",
	:external_encoding=>"ASCII-8BIT");
play.binmode

read_bfr_string = "";
current_sample_buffer = [];

out_sample_buffer = [];
echo_buffer = Array.new(6000, 0);

def set_fb_frequency(freq)
  $fb_delay = 32000 / freq;
  $samp_increase = 40 * 2 * Math::PI / 32000;
end
$samp_time = 0;
set_fb_frequency(160)

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

	$outFile&.write current_sample_buffer.pack("s<*");

	play.write out_sample_buffer.pack("s<*");
end
