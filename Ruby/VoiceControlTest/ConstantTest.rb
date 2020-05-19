
require 'tef/furcoms.rb'
require 'tef/animation.rb'

require 'mqtt/sub_handler'

$mqtt = MQTT::SubHandler.new('localhost');

$direct_port = TEF::FurComs::SerialToMQTT.new('/dev/ttyACM0', $mqtt);
$port = TEF::FurComs::MQTT.new($mqtt);

$animation_core = TEF::Animation::Handler.new($port)

$parameters = TEF::ParameterStack::Stack.new();

$sequencePlayer = TEF::Sequencing::Player.new();
$sequencePlayer.after_exec {
	$parameters.process_changes
	$animation_core.update_tick
}

speech_box = $animation_core['S100M0'] = TEF::Animation::Box.new 0;
speech_box.configure up: 3, down: 3, left: 3, right: 3

eye = $animation_core['S10M0'] = TEF::Animation::Eye.new
eye.configure({
	outer_color: { delay_a: 10, delay_b: 10 },
	top: { add: -3, dampen: 0.1, delay: 0.02 },
	bottom: { add: 3, dampen: 0.1, delay: 0.02 },

	iris_x: { dampen: 0.1 },
	iris_y: { add: 3, dampen: 0.05 },
});

$parameters.on_recompute 'Palette/SpeechOn', 'Palette/SpeechOff', 'SpeechLevel' do
	$parameters['SpeechColor'] = ($parameters['SpeechLevel'] ?
		$parameters['Palette/SpeechOn'] : $parameters['Palette/SpeechOff']);
	$parameters['Eye/Color'] = $parameters['Palette/SpeechOff']
end
$parameters.on_change 'Palette/SpeechOff' do
	eye.outer_color = $parameters['Palette/SpeechOff']
end
$parameters.on_change 'Palette/SpeechDelay', 'SpeechColor' do
	speech_box.color.delay_a = $parameters['Palette/SpeechDelay']
	speech_box.color = $parameters['SpeechColor'] || 0xFF000000
end

$parameters.on_change('Eye/Top')    { eye.top = $parameters['Eye/Top'] }
$parameters.on_change('Eye/Bottom') { eye.bottom = $parameters['Eye/Bottom'] }
$parameters.on_change('Eye/IrisX') { eye.iris_x = $parameters['Eye/IrisX'] + 0.5 }
$parameters.on_change('Eye/Color') { eye.outer_color = $parameters['Eye/Color']}

$parameters['Palette/SpeechOn']  = 0x0090B0
$parameters['Palette/SpeechOff'] = 0x005050
$parameters['Palette/SpeechDelay'] = 10

$parameters['Eye/Top'] = -3;
$parameters['Eye/Bottom'] = 3;
$parameters['Eye/IrisX'] = 2;

$program_selector = TEF::ProgramSelection::Selector.new()

$soundmap = TEF::ProgramSelection::SoundCollection.new($program_selector);
$sheetmap = TEF::ProgramSelection::SequenceCollection.new($program_selector, $sequencePlayer)

Dir.glob('sheets/**/*.rb').each { |fn| load fn }

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

def play(name)
	return unless effect = $program_selector.fetch_string(name)
	$sheetmap.play effect
end

play("power up start")

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
