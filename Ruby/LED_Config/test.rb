
$keys = [ :x, :y ];

$test_led_strip = {
	31 => { y: -10, x: 3}, 39 => { y: -26, x: 8},
	40 => { y: -24, x: 3}, 41 => { y: -24, x: 1},
	42 => { y: -22, x: -1}, 43 => { y: -20, x: -3 },
	44 => { y: -18, x: -2.5}, 49 => { y: -10, x: -1},
	50 => { x: 0, y: -8}, 51 => { x: 2, y: -8},
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
