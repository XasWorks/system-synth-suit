
$keys = [ :x, :y, :e, :es ];

$test_led_strip = {
	31 => { y: -10, x: 3, e: 1, es: 0.9}, 38 => { y: -26, x: 8, e: 1, es: 0},
	39 => { y: -24, x: 5, e: 0, es: 0}, 41 => { y: -24, x: 1, e: 0, es: 0.25},
	42 => { y: -22, x: -1, e: 0, es: 0.5}, 43 => { y: -20, x: -3, e: 0, es: 0.75 },
	44 => { y: -18, x: -2.5, e: 1, es: 0}, 49 => { y: -10, x: -1, e: 1, es: 0.9},
	50 => { x: 0, y: -8, e: 1, es: 1}, 51 => { x: 2, y: -8, e: 1, es: 1},
	52 => { x: -2.5, y: -20, e: -1, es: 1}, 57 => { x: -4, y: -28, e: -1, es: 0.4 },
	58 => { x: -4, y: -30, e: -1, es: 0.35}, 61 => { x: 0, y: -36, e: -1, es: 0},
	62 => { x: 1, y: -35, e: -1, es: 0}, 68 => { x: 4, y: -28, e: -1, es: 1 }
}


$table_output = ""

def interpolate(low, high, fact)
	out = {}
	$keys.each do |key|
		out[key] = (low[key] || 0) * (1.0-fact) + (high[key] || 0) * fact;
	end

	return out;
end

def add_led_entry(facts)
	$table_output += "{ #{$keys.map do |k| ".#{k} = #{facts[k] || 0}" end.join(", ") }},\n"
end

start_num = $test_led_strip.keys.min
end_num   = $test_led_strip.keys.max

led_segment_index = 0;
current_top = nil;
current_bottom_n = 0;
current_bottom = nil;
current_delta_n = 0;

(start_num..end_num).each do |n|
	if($test_led_strip.keys[led_segment_index] == n)
		add_led_entry($test_led_strip[n])

		led_segment_index += 1;

		current_bottom_n = $test_led_strip.keys[led_segment_index-1];
		current_bottom = $test_led_strip.values[led_segment_index-1];

		current_delta_n = ($test_led_strip.keys[led_segment_index] || end_num) - current_bottom_n;
		current_top = $test_led_strip.values[led_segment_index];

		puts "Segment: #{led_segment_index} Bottom: #{current_bottom_n} Delta: #{current_delta_n}"
	else
		add_led_entry(interpolate(current_bottom, current_top, (n.to_f - current_bottom_n) / current_delta_n));
	end
end


puts "Output is:\n\n"
puts $table_output
