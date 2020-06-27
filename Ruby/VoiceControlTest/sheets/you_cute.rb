
TEF::ProgramSelection::ProgramSheet.new() do |s|
	s.add_key "you are cute"

	s.sequence do
		@eye = $animation_core['S1M0'];
		@string = $animation_core['S1M1'];

		@string.color = 0xFFFF00;

		@eye.set_mood :surprised

		3.times do |i|
			at 0.3 * i + 0.1 do
				@string.string = "!"
			end

			after 0.15 do
				@string.string = " "
			end
		end

		after 0.2 do
			@eye.iris_x = 7;
			@eye.set_mood :shy
			@eye.blush = 0xE91E63
		end

		after 3 do
			@eye.set_mood :happy
			@eye.iris_x = 2;
			@eye.blush = 0xFF000000;

			@string.string = 'No u'
			@string.color = 0x00AA00;
			@string.color.jump = 0x00AA00;
		end

		after 3 do end
	end

	s.teardown do
		@eye.set_mood :relaxed
		@eye.blush = 0xFF000000
		@string.string = ' '
	end
end
