

module TEF
	module Animation
		class Sequence
			attr_accessor :start_time
			attr_accessor :end_time

			attr_reader :event_list
			attr_reader :subsequence_list

			attr_reader :setup_block
			attr_reader :teardown_block

			def initialize(&block)
				@last_evt_time = 0

				@event_list = []
				@subsequence_list = []

				@start_time = 0;
				@end_time = nil;

				@setup_block = nil;
				@teardown_block = nil;

				instance_eval(&block) if block_given?
			end

			def within_time(start_t, end_t)
				return false if !end_t.nil? && end_t < @sequence.start_time
				return false if !@sequence.nil? && start_t > @end_time

				true
			end

			# TODO Add subsequence creation parameters
			def subsequence(offset, &seq_block)
				raise ArgumentError, 'Time must be Numeric!' unless time.is_a? Numeric
				raise ArgumentError, 'Block must be given!' unless block_given?

				out_seq = Sequence.new()
				out_seq.instance_eval(&seq_block)

				new_seq = {
					offset: offset,
					seq: out_seq
				}

				@subsequence_list << new_seq
			end

			def setup(&block)
				@setup_block = block;
			end
			def teardown(&block)
				@teardown_block = block;
			end

			def at(time, &block)
				raise ArgumentError, 'Time must be Numeric!' unless time.is_a? Numeric
				raise ArgumentError, 'Block must be given!' unless block_given?

				new_event = {
					time: time,
					code: block,
					instance: self
				}

				@last_evt_time = time;

				i = @event_list.bsearch_index { |element| element[:time] > time}
				@event_list.insert i || -1, new_event
			end

			def after(time, &block)
				at @last_evt_time + time, &block
			end
		end
	end
end
