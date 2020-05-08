
require_relative 'Sequence.rb'

module TEF
	module Animation
		class SequenceInstance
			attr_accessor :offset

			def initialize(seq)
				@sequence = seq

				@subsequence_list = seq.subsequence_list.map do |seq_def|
					SequenceInstance.new(seq_def[:seq]).offset = seq_def[:offset]
				end

				@state = :uninitialized

				@offset = 0
			end

			def run_setup()
				return unless @state == :uninitialized

				block = @sequence.setup_block
				instance_eval(&block) if @block

				@state = :ready
			end

			def run_teardown()
				return unless @state == :ready

				@subsequence_list.each(&:run_teardown)

				block = @sequence.teardown_block
				instance_eval(&block) if block

				@state = :uninitialized
			end

			private def raw_internal_events(start_time, end_time)
				list = @sequence.event_list
				i = list.bsearch_index { |element| element[:time] > start_time }

				return nil if i.nil?

				o_time = list[i][:time]

				return nil if !end_time.nil? && o_time > end_t

				list.select { |element| element[:time] == o_time }
			end

			private def raw_subsequence_events(start_time, end_time)
				out_list = nil;
				out_time = end_time;

				@subsequence_list.each do |subsequence|
					sub_elements = subsequence.next_events(start_time, out_time);

					next unless sub_elements

					sub_time = sub_elements[0][:time]
					if !out_time.nil? && sub_time == out_time
						out_list += sub_elements
					else
						out_list = sub_elements
						out_time = sub_time
					end
				end

				out_list
			end

			private def raw_next_events(start_t, end_t)
				return nil unless @sequence.within_time(start_t, end_t)

				if @state == :uninitialized
					return [{
						time: start_t,
						code: proc { run_setup },
						instance: self,
					}]
				end

				out_evt = nil;
				out_time = nil;

				if @state == :ready
					out_evt  = raw_internal_events(start_t, end_t)
					out_time = out_evt&.at(0)&.dig(:time)

					if sub_evt = raw_subsequence_events(start_t, out_time || end_t)
						sub_time = sub_evt[:time];

						if(sub_time == out_time)
							out_evt += sub_evt
						else
							out_evt = sub_evt
							out_time = sub_time
						end
					end
				end

				if out_evt.nil? &&
					!@end_time.nil? &&
					@end_time < end_t &&
					@state == :ready

					return [{
						time: @end_time,
						code: proc { run_teardown },
						instance: self,
					}]
				end

				out_evt
			end

			def next_events(start_time, end_time = nil)
				end_time -= @offset unless end_time.nil?

				events = raw_next_events(start_time - @offset, end_time);

				return nil if events.nil?

				events.map do |event|
					event = event.clone;
					event[:time] += @offset;
					event
				end
			end
		end
	end
end
