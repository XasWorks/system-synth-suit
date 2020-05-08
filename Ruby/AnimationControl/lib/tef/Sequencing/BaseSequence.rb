
require_relative 'EventCollector.rb'

module TEF
	module Sequencing
		class BaseSequence
			attr_reader :start_time
			attr_reader :end_time

			attr_reader :offset
			attr_reader :slope

			attr_reader :state

			def initialize(offset, slope, **options)
				@start_time ||= options[:start_time] || 0;
				@end_time   ||= options[:end_time];

				@offset = offset;
				@slope  = slope;

				@state = :uninitialized

				@opts_hash = options;
			end

			def parent_start_time
				@offset + @start_time / @slope
			end

			def setup()
				raise 'Program had to be uninitialized!' unless @state == :uninitialized
				@state = :running
			end

			def teardown()
				return unless @state == :running
				@state = :torn_down

				@opts_hash = nil;
			end

			def append_events(collector)
				local_collector = collector.offset_collector(@offset, @slope);

				return if local_collector.has_events? &&
							 local_collector.event_time < @start_time
				return if @state == :torn_down

				if @state == :uninitialized
					local_collector.add_event({
						time: @start_time,
						code: proc { self.setup() }
					});
				end

				if @state == :running
					overload_append_events(local_collector)
				end

				if !@end_time.nil?
					local_collector.add_event({
						time: @end_time,
						code: proc { self.teardown }
					})
				end
			end

			def overload_append_events(_collector) end
		end
	end
end
