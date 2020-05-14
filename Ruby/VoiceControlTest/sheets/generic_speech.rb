

generic_sheet = TEF::Sequencing::Sheet.new();

generic_sheet.sequence do
	return unless @opts_hash[:silences]

	@params = TEF::ParameterStack::Override.new($parameters);

	if @opts_hash[:sound_id].groups.include? 'i guess'
		@params['Palette/SpeechOn']  = 0xB09000
		@params['Palette/SpeechOff'] = 0x505000
	end

	at(0.1) { @end_time = nil }

	@opts_hash.dig(:extra_config, 'Overrides')&.each do |t, overrides|
		at t do
			overrides.each { |key, value| @params[key] = value }
		end
	end

	@opts_hash[:silences].each do |t, l|
		at t do
				@params['SpeechLevel'] = (l == 1)
		end
	end

	after 0.6 do end
end

generic_sheet.teardown do
	@params.destroy!
end

puts "Soundmap loaded conf is #{$soundmap.load_config}"

$soundmap.soundmap.each do |id, fname|
	next if $sheetmap[id]

	$sheetmap[id] = generic_sheet;
	$sheetmap.sheet_opts[id] = {
		sound_id: id,
		silences: $soundmap.silence_maps[fname],
		extra_config: $soundmap.load_config[fname] || {},
	}
end
