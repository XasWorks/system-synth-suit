
TEF::ProgramSelection::ProgramSheet.new() do |s|
	s.add_key "long time", ["portal", "glad os"]

	s.sequence do
		@speech_box = (
		$animation_core['S100M0'] ||= TEF::Animation::Box.new(3));

		@speech_box.up.jump = 4
		@speech_box.up.dampen = 0.5
		@speech_box.up = 4

		@speech_box.left = @speech_box.up
		@speech_box.right = @speech_box.up
		@speech_box.down = @speech_box.up

		@speech_box.color.delay_a = 4

		@speech_box.color = 0x605000

		def boop(time)
			at time do
				@speech_box.color = 0xFFA000
				@speech_box.up = 10
			end

			at time + 0.1 do
				@speech_box.color = 0x605000
				@speech_box.up = 4
			end
		end

		def longboop(time)
			at time do
				@speech_box.color = 0xFFA000
				@speech_box.up = 10
			end

			at time + 0.4 do
				@speech_box.color = 0x605000
				@speech_box.up = 4
			end
		end

		boop 0.3
		boop 0.55
		boop 0.758
		longboop 0.89
		longboop 1.6

		boop 3.24
		boop 3.427
		boop 3.682
		boop 3.885
	end
end
