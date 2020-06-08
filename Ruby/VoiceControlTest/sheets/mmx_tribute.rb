
NOTE_CONFIGS = [
	{ up: 100, down: -5, left: 4, right: -1.5, color: { delay_a: 4 }},
	{ up: 100, down: -5, left: 1.5, right: 1, color: { delay_a: 4 }},
	{ up: 100, down: -5, left: 0, right: 2, color: { delay_a: 4 }},
	{ up: 100, down: -5, left: -2.5, right: 4, color: { delay_a: 4 }},
	{ up: 100, down: 100, left: -6, right: 100, color: { delay_a: 4 }}
]

TEF::ProgramSelection::ProgramSheet.new() do |s|
	s.add_key "pipe dream"

	s.sequence do
		play './sound_snips/marble_machine_short.mp3', 1

		def bass_beep(num)
			box = $animation_core["S101M#{num+50}"] = TEF::Animation::Box.new(3);
			box.configure(NOTE_CONFIGS[num]);

			box.color.jump = 0x0000FF;
			box.die_in 2
		end

		@crank_box = $animation_core['S101M0'] = TEF::Animation::Box.new(3)
		@crank_box.configure(up: 2.1, down: -1, left: 0.8, right: 0.8,
			rotation: { dampen: 0.58, delay: 8, add: 10, from: 'S101M0V0' }, color: 0x0000FF);

		bass_positions = {}
		File.readlines('./sheets/mmx_labels.txt').each do |line|
			next unless line =~ /([\d\.]+)\s+[\d\.]+\s+(\d)/
			bass_positions[$1.to_f] = $2.to_i
		end

		puts "Bass decode is: #{bass_positions}"

		bass_positions.each do |t, i|
			at(t) {
				bass_beep i
			}
		end
	end

	s.end_time = 30

	s.teardown do
		$animation_core['S101M0'] = nil;
	end
end
