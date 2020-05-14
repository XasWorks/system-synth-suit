
require 'pocketsphinx-ruby'

require '~/Xasin/system-synth-suit/tef-FurComs/Ruby/lib/tef/furcoms/Serial.rb'
require_relative '../AnimationControl/lib/tef/Animation/Animation_Handler.rb'

require_relative '../AnimationControl/lib/tef/Sequencing/SequencePlayer.rb'
require_relative '../AnimationControl/lib/tef/ProgramSelection/SoundCollection.rb'
require_relative '../AnimationControl/lib/tef/ProgramSelection/SequenceCollection.rb'

$port = TEF::FurComs::Serial.new('/dev/ttyACM0');

$animation_core = TEF::Animation::Handler.new($port)

$sequencePlayer = TEF::Sequencing::Player.new();
$sequencePlayer.after_exec { $animation_core.update_tick }

$program_selector = TEF::ProgramSelection::Selector.new()

$soundmap = TEF::ProgramSelection::SoundCollection.new($program_selector);
$sheetmap = TEF::ProgramSelection::SequenceCollection.new($program_selector, $sequencePlayer)

$ambiance_level = 'silent';

load 'magic_play.rb'

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
	$soundmap.play effect
	$sheetmap.play effect
end

play("long time")

sleep 1

play("power up start")

$pocket_reader.recognize do |t|
	if m = /computer ambiance level (.*)/.match(t)
		$ambiance_level = m[1];

		puts "Ambiance to level #{$ambiance_level}"
	else
		play t
	end
end
