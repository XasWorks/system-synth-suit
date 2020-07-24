

speech_box = $animation_core['S100M0'] = TEF::Animation::Box.new 3;
speech_box.configure up: 3, down: 3, left: 3, right: 3

eye = $animation_core['S1M0'] = TEF::Animation::Eye.new
eye.configure({
	outer_color: { delay_a: 3, delay_b: 3 },
	iris_x: { dampen: 0.1 },
});

$animation_core['S1M1'] = TEF::Animation::StringDisplay.new;

$parameters.on_recompute 'Palette/SpeechOn', 'Palette/SpeechOff', 'SpeechLevel' do
	$parameters['SpeechColor'] = ($parameters['SpeechLevel'] ?
		$parameters['Palette/SpeechOn'] : $parameters['Palette/SpeechOff']);

	$parameters['Eye/Color'] = $parameters['Palette/SpeechOn']
	$parameters['Face/TextColour'] = $parameters['Palette/SpeechOn'];
end
$parameters.on_change 'Palette/SpeechOff' do
	eye.outer_color = $parameters['Palette/SpeechOff']
end
$parameters.on_change 'Palette/SpeechDelay', 'SpeechColor' do
	speech_box.color.delay_a = $parameters['Palette/SpeechDelay']

	s_colour = $parameters['SpeechColor'] || 0xFF000000;
	speech_box.color = s_colour;
end

$parameters.on_change('Eye/Mood') do
	eye.set_mood($parameters['Eye/Mood'])
end
$parameters.on_change('Eye/IrisX')  {
	eye.iris_x = $parameters['Eye/IrisX']
}
$parameters.on_change('Eye/Color')  {
	eye.outer_color = $parameters['Eye/Color']
}

$parameters.on_recompute 'Face/Text' do
	$parameters['SpeechLevel'] = !$parameters['Face/Text'].empty?
end

text_box = $animation_core['S1M1'];
text_box.configure({
	x: { dampen: 0.3, delay: 0.2 , add: 0 }
});

$parameters.on_change('Face/Text')  { text_box.string = $parameters['Face/Text'] }
$parameters.on_change('Face/TextColour') { text_box.color = $parameters['Face/TextColour'] }
$parameters.on_change('Face/TextX') { text_box.x = $parameters['Face/TextX'] }

$parameters['Palette/SpeechOn']  = 0x0090B0
$parameters['Palette/SpeechOff'] = 0x005050
$parameters['Palette/SpeechDelay'] = 5

$parameters['Eye/IrisX'] = 2;

$parameters['Face/Text'] = '';
$parameters['Face/TextX'] = 0;
