
require 'mqtt/sub_handler'
require 'pocketsphinx-ruby'

$mqtt = MQTT::SubHandler.new('localhost');


$file_queue = Queue.new()

$mqtt.subscribe_to 'Pocketsphinx/Request' do
	$file_queue << '/tmp/Memeinator.raw'
end

pocket_cfg = Pocketsphinx::Configuration::Grammar.new("Control.JSGF");
pocket_cfg['logfn'] = "/dev/null"

$pocket_reader = Pocketsphinx::AudioFileSpeechRecognizer.new(pocket_cfg);
$pocket_reader.recognize('./Primer.raw') do |result| end

loop do
	fname = $file_queue.pop

	$pocket_reader.recognize fname do |data|
		$mqtt.publish_to "Pocketsphinx/Result", data
	end
end
