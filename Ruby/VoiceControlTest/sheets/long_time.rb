
TEF::ProgramSelection::ProgramSheet.new() do |s|
	s.add_key "long time", ["portal", "glad os"]

	s.sequence do
		@params = TEF::ParameterStack::Override.new($parameters, 1);

		@params['Palette/SpeechDelay'] = 20
		@params['Palette/SpeechOn']    = 0xFFA000
		@params['Palette/SpeechOff']   = 0x605000

		play './sounds/portal/glad_os/long_time.mp3'

		def boop(time)
			at time do
				@params['SpeechLevel'] = true
			end

			at time + 0.1 do
				@params['SpeechLevel'] = false
			end
		end

		def longboop(time)
			at time do
				@params['SpeechLevel'] = true
			end

			at time + 0.4 do
				@params['SpeechLevel'] = false
			end
		end

		boop 0.3
		boop 0.55
		boop 0.758
		longboop 0.89
		longboop 1.6

		boop 3.24
		boop 3.427
		boop 3.682
		boop 3.885
	end

	s.teardown { @params.destroy! }
end
