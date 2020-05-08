

generic_sheet = TEF::Sequencing::Sheet.new();

generic_sheet.sequence do
	return unless @opts_hash[:silences]

	@speech_box = (
	$animation_core['S100M0'] ||= TEF::Animation::Box.new 0);

	@speech_box.up = 3
	@speech_box.left = 3;
	@speech_box.right = 3;
	@speech_box.down = 3;

	@speech_box.color.delay_a = 10
	@speech_box.color = 0x006060

	def set_level(i)
		if i == 1
			@speech_box.color = 0x0090B0
		else
			@speech_box.color = 0x006060
		end
	end

	@opts_hash[:silences].each do |t, l|
		at t do
			set_level l
		end
	end
end

generic_sheet.teardown do
	@speech_box.color = 0x006060
end

$soundmap.silence_maps.each do |id, levels|
	next if $sheetmap[id]

	$sheetmap[id] = generic_sheet;
	$sheetmap.sheet_opts[id] = { silences: levels }
end
