
CRYSTAL_PEAK_POWERS = {}

loop do
	temp_powers = [
		'two', 'two', 'two', 'two',
		'two', 'two', 'two', 'two', 				# 100 - 107

		'one', 'one', 'one', 'one',					# 108 - 111

		1.5, 1.5,
		2, 2,
		2.5, 2.5, 2.5, 2.5,					# 115 - 118, 119 not suitable
		'three', 'three',							# 122, 121

		'four', 'four', 'four',	'four',		# 122, 123, 124, 125,
		'four', 'four', 'four', 'four', 		# 126, 127, 128, 129
	]
	temp_powers.each_index do |i|
		CRYSTAL_PEAK_POWERS[temp_powers[i]] ||= [];
		CRYSTAL_PEAK_POWERS[temp_powers[i]] << i;
	end

	break;
end

TEF::ProgramSelection::ProgramSheet.new() do |s|
	s.add_key "crystal peak ambiance"
	s.program_key = 'ambiance'

	s.sequence do
		@current_note = 0;

		at 0.01 do
			if map = CRYSTAL_PEAK_POWERS[$parameters['Ambiance/Level']]
				play "./sound_snips/hollow_knight/crystal_peak-#{map[@current_note % map.length]+100}.mp3"
			end

			@current_note += 1;
		end

		at 8 do
			@offset += 8
		end

		after 0.1
	end

	s.teardown do
		$animation_core['S105M0'] = nil
	end
end
