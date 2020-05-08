

require_relative 'Animation_Handler.rb'
load '~/Xasin/system-synth-suit/tef-FurComs/Ruby/lib/tef/furcoms/Serial.rb'

require_relative 'Sequence_Instance.rb'

$port = TEF::FurComs::Serial.new('/dev/ttyACM0');
$port.log_level = Logger::DEBUG

$handler = TEF::Animation::Handler.new($port)

Thread.new do
	loop do
		sleep 0.1

		$handler.update_tick()
	end
end.abort_on_exception = true

$box = TEF::Animation::Box.new 1

$box.up = 1
$box.down = 1
$box.left = 40
$box.right = 40

$box.left.velocity  = 5
$box.right.velocity = 5

$box.left.dampen = 1
$box.left.delay = 1
$box.right.dampen = 1
$box.right.delay = 1

$box.color = 0xFFC046

c = $box.center
c.x = 2
c.y = 5

c.y.dampen = 0.05
c.y.delay = 8

$test_seq_profile = TEF::Animation::Sequence.new() do
	setup do
		puts "I set up :D"
	end

	at 1 do
		$box.center.y = 7
	end

	at 2 do
		$box.center.y = 1

		nBox = TEF::Animation::Box.new(3)

		nBox.up = 40
		nBox.down = 40
		nBox.left = 2
		nBox.right = 1

		nBox.color = 0x040277bd

		nBox.center.x.jump = 10
		nBox.center.x.dampen = 0.1
		nBox.center.x.delay = 100

		nBox.center.x.velocity = -20

		nBox.die_in 5

		$handler['S100M5'] = nBox
	end

	teardown do
		puts "And I tore down, lovely~"
	end
end

$test_seq = TEF::Animation::SequenceInstance.new($test_seq_profile)

bb = $handler['S100M1'] = TEF::Animation::Box.new(2);
bb.x_dir.x = 0
bb.y_dir.y = 0
bb.up = 40
bb.down = 40
bb.left = 40
bb.right = 040

bb.color = 0xF0B55000

$handler['S100M0'] = $box

spinBox = $handler['S100M2'] = TEF::Animation::Box.new();

spinBox.up = 2.5
spinBox.down = -1.5
spinBox.left = 1
spinBox.right = 1

# spinBox.rotation.from = spinBox.rotation
# spinBox.rotation.add = 0.06

spinBox.color = 0xA000FF00

sleep 0.2

$start_time = Time.now();
$target_time = Time.now();

loop do
	btime_a = Time.now();
	next_evts = $test_seq.next_events($target_time - $start_time)
	btime_b = Time.now();

	puts "Time: #{btime_b - btime_a}"

	if next_evts.nil?
		$start_time = Time.now() + 0.1
		next
	end

	$target_time = $start_time + next_evts[0][:time]

	sleep [$target_time - Time.now(), 0].max

	next_evts.each do |evt|
		if instance = evt[:instance]
			instance.instance_eval(&evt[:code])
		else
			evt[:code].call
		end
	end
end
