
require_relative 'BaseSequence.rb'
require_relative 'EventCollector.rb'

require_relative 'SheetSequence.rb'

module TEF
	module Sequencing
		class Player
			def initialize()
				@activeSequences = {}
				@sequenceMutex = Mutex.new

				@post_exec_cbs = []

				@collector = EventCollector.new()

				@retryCollecting = false

				@playThread = Thread.new do
					_run_play_thread()
				end

				@playThread.abort_on_exception = true
			end

			def after_exec(&block)
				@post_exec_cbs << block if block_given?
			end

			def []=(key, program)
				@sequenceMutex.synchronize do
					if @activeSequences[key]
						@activeSequences[key].teardown
					end

					if program.is_a? Sheet
						puts "Inited sheet with start at #{Time.now()}"
						program = SheetSequence.new(Time.now(), 1, sheet: program)
					end

					@activeSequences[key] = program
					@retryCollecting = true
				end

				@playThread.run();

				program
			end

			def delete(key)
				@sequenceMutex.synchronize do
					if @activeSequences[key]
						@activeSequences[key].teardown
					end

					@activeSequences.delete key
					@retryCollecting = true
					@playThread.run();
				end
			end

			def [](key)
				@activeSequences[key]
			end

			private def _run_play_thread()
				loop do
					@sequenceMutex.synchronize do
						@retryCollecting = false
						@activeSequences.delete_if { |k, seq| seq.state == :torn_down }
						@activeSequences.each { |k, seq| seq.append_events @collector }
					end

					if @collector.has_events?
						@collector.wait_until_event
					else
						Thread.stop
					end

					if @retryCollecting
						@collector.restart
					else
						@collector.execute!
						@post_exec_cbs.each(&:call)
					end
				end
			end
		end
	end
end
