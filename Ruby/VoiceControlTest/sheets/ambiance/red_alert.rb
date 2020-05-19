
TEF::ProgramSelection::ProgramSheet.new do |s|
	s.program_key  = 'ambiance'

	s.add_key 'computer red alert', ['star trek', 'voyager']
	s.add_key 'computer blue alert', ['star trek', 'voyager']
	s.add_key 'computer stand down alert', ['star trek', 'voyager']

	s.sequence do
		next if @opts_hash[:program_key].title == 'computer stand down alert'

		@alert_background = TEF::Animation::Box.new(0);
		$animation_core['S105M0'] = @alert_background

		@alert_background.configure({
			up: 7, down: -4, left: 10, right: 10,
			color: { target: 0xFFFF0000, delay_a: 18, delay_b: 5},
		});

		if @opts_hash[:program_key].title == 'computer red alert'
			@alert_on_color  = 0xFF0000
			@alert_off_color = 0x440000
			@alert_sound = './sounds/star_trek/voyager-red_alert.mp3'
		else
			@alert_on_color  = 0x0000FF
			@alert_off_color = 0x000044
			@alert_sound = './sounds/star_trek/voyager-blue_alert.mp3'
		end

		at 0.01 do
			@old_pid = play @alert_sound

			@alert_background.color.velocity = @alert_on_color
			@alert_background.color.target   = @alert_on_color
		end

		at 0.6 do
			@alert_background.color.target = @alert_off_color
		end

		at 2.3 do
			kill @old_pid
			@offset += 3
		end
	end

	s.teardown do
		$animation_core['S105M0'] = nil;
	end
end
