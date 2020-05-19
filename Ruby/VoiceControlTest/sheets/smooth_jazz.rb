
TEF::ProgramSelection::ProgramSheet.new() do |s|
	s.add_key "smooth jazz", ["portal", "announcer"]

	s.sequence do
		@speech_box = (
		$animation_core['S100M0'] ||= TEF::Animation::Box.new 0);

		play './sounds/portal/announcer/smooth_jazz.mp3'

		@speech_box.up = 3
		@speech_box.left = 3;
		@speech_box.right = 3;
		@speech_box.down = 3;

		@speech_box.color.delay_a = 10

		@speech_box.color = 0x006060

		def say(t, dur = 0.15, c = 0x0090B0)
			puts "Adding speech at #{t}"

			at t do
				@speech_box.color = c
			end

			at t + dur do
				@speech_box.color = 0x006060
			end
		end

		say(0.134)
		say(0.369)
		say(0.571, 0.2)
		say(0.95, 0.27)

		2.times do |i|
			at 1.3 + i*0.7 do
				@speech_box.color = 0xFFA000
			end
			after 0.35 do
				@speech_box.color = 0x555500
			end
		end

		say 3.1, 0.2  # Tranquil
		say 3.5, 0.3  # In the face of
		say 4.2, 0.35, 0xBBB500 # Almost
		say 4.6, 0.35, 0xBB7000 # Certain
		say 5, 0.6,   0xBB2200 # Death

		say 5.6, 0.3 # Smooth
		say 6, 0.3 # Jazz

		say 6.5, 0.6 # Will be deployed
		say 7.5

		say 7.8, 0.5
		say 8.7, 0.5
		say 9.5, 0.5

		at 9.7 do
			@spinbox = TEF::Animation::Box.new(3);
			$animation_core['S101M0'] = @spinbox;

			@spinbox.rotation.from = @spinbox.rotation
			@spinbox.rotation.velocity = 1
			@spinbox.rotation.add = 2
			@spinbox.rotation.dampen = 0.2
			@spinbox.rotation.delay = 1

			@spinbox.up = 5
			@spinbox.left = 1
			@spinbox.right = 1
			@spinbox.down = -1

			@spinbox.color = 0x0000FF00

			@spinbox.die_in 14
		end

		at(18) { @spinbox.rotation.add = 0.05 }

		7.times do
			say 20 + rand()*5, 0.1 + 0.2*rand(), 0x000000
		end
	end
end
