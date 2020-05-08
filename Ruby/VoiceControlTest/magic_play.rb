

powerlist = [
	'two', 'two', 'two', 'two',
	'two', 'two', 'two', 'two', 				# 100 - 107

	'one', 'one', 'one', 'one',					# 108 - 111

	1.5, 1.5,
	2, 2,
	2.5, 2.5, 2.5, 2.5,					# 115 - 118, 119 not suitable
	'three', 'three',							# 122, 121

	'four', 'four', 'four',	'four',		# 122, 123, 124, 125,
	'four', 'four', 'four', 'four', 		# 126, 127, 128, 129
];

$powermap = {}

powerlist.each_index do |i|
	$powermap[powerlist[i]] ||= [];
	$powermap[powerlist[i]] << i;
end

$current_note_step = -1;

def play_next()
	$current_note_step += 1;

	if map = $powermap[$ambiance_level]
		Thread.new() do
			`play -q sound_snips/hollow_knight/crystal_peak-#{map[$current_note_step % map.length]+100}.mp3`
		end
	end
end

Thread.new do
	loop do
		play_next()
		sleep 8
	end
end.abort_on_exception = true
