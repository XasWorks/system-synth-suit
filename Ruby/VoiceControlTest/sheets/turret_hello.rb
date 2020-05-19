
TEF::ProgramSelection::ProgramSheet.new do |s|
	(1..4).each do |i|
		s.add_key "hello", ["portal", "turret"], "-#{i}.mp3"
	end

	s.sequence do
		@speech_box = (
		$animation_core['S100M0'] ||= TEF::Animation::Box.new(1));

		play "./sounds/portal/turret/hello-#{rand(1..4).to_i}.mp3"

		at 0.1 do
			@speech_box.color.delay_a = 2
			@speech_box.color = 0x00A040

			@wave_box = TEF::Animation::Box.new(3);
			$animation_core['S101M0'] = @wave_box

			@wave_box.up = 30
			@wave_box.down = 30
			@wave_box.left = 1
			@wave_box.right = 1

			@wave_box.color.jump = 0xFF000000
			@wave_box.color = 0x00FF00
			@wave_box.color.delay_a = 10

			# c.velocity = 20
			# c.jump = 0

			@wave_box.die_in 12
		end

		at 0.3 do
			c = @wave_box.rotation
			c.dampen = 0.03
			c.velocity = 0
			c.jump = 0
		end

		20.times do |i|
			at(0.5 * i) { @wave_box.rotation = -0.6 }
			after(0.25) { @wave_box.rotation = 0.2 }
		end
	end

	s.end_time = 10

	s.teardown do
		@speech_box.color = 0x006060
		@wave_box.color = 0xFF000000
		@wave_box.die_in 2
	end
end
