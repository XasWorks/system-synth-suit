
require 'xasin_logger'

module TEF
	module Sequencing
		class OffsetCollector
			attr_reader :parent

			attr_reader :total_offset
			attr_reader :total_slope

			def initialize(parent, total_offset, total_slope)
				@parent = parent
				@total_offset = total_offset
				@total_slope  = total_slope
			end

			def convert_to_local(global_time)
				return nil if global_time.nil?

				(global_time - @total_offset) * @total_slope
			end
			def convert_to_global(local_time)
				return nil if local_time.nil?

				@total_offset + (local_time.to_f / @total_slope)
			end

			def start_time
				convert_to_local @parent.start_time
			end

			def event_time
				convert_to_local @parent.event_time
			end

			def has_events?
				return @parent.has_events?
			end

			def add_event(event)
				event = event.clone

				event[:time] = convert_to_global event[:time]

				@parent.add_event event
			end

			def add_events(list)
				list.each { |event| add_event event }
			end

			def offset_collector(offset, slope)
				OffsetCollector.new(@parent, convert_to_global(offset), @total_slope * slope)
			end
		end

		class EventCollector
			include XasLogger::Mix

			attr_accessor :start_time
			attr_reader   :event_time

			attr_reader :current_events

			def initialize()
				@current_events = []
				@start_time = Time.at(0);
				@event_time = nil;

				init_x_log("Sequence Player")
			end

			def add_event(event)
				return if event[:time] <= @start_time
				return if (!@event_time.nil?) && (event[:time] > @event_time)

				if (!@event_time.nil?) && (event[:time] == @event_time)
					@current_events << event
				else
					@current_events = [event]
					@event_time = event[:time]
				end
			end

			def has_events?
				!@current_events.empty?
			end

			def wait_until_event
				return unless has_events?

				t_diff = @event_time - Time.now();

				if t_diff < -0.5
					x_logf('Sequence long overdue!')
				elsif t_diff < -0.1
					x_logw('Sequencing overdue')
				end

				sleep t_diff if t_diff > 0
			end

			def execute!
				return unless has_events?

				wait_until_event

				@current_events.each do |event|
					event[:code].call()
				end

				@start_time = @event_time
				restart();
			end

			def restart()
				@current_events = []
				@event_time = nil;
			end

			def offset_collector(offset, slope)
				OffsetCollector.new(self, offset, slope);
			end
		end
	end
end
