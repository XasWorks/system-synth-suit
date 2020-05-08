
require_relative 'BaseSequence.rb'
require_relative 'Sheet.rb'

module TEF
	module Sequencing
		class SheetSequence < BaseSequence
			def initialize(offset, slope, **options)
				super(offset, slope, **options);

				raise ArgumentError, 'Sheet must be supplied!' unless options[:sheet]

				@sheet = options[:sheet]

				if @sheet.tempo
					@slope *= @sheet.tempo / (60 * (options[:top_slope] || 1))
				end

				@start_time = @sheet.start_time
				@end_time = @sheet.end_time

				@notes = []
				@latest_note_time = nil;

				@subprograms = []
			end

			def setup()
				super();

				if block = @sheet.setup_block
					instance_exec(@opts_hash[:sheet_options], &block)
				end

				return unless @end_time.nil?
				@end_time = @notes[-1][:time]
			end

			def teardown()
				return unless @state == :running

				if block = @sheet.teardown_block
					instance_eval(&block)
				end

				@subprograms.each(&:teardown)

				@subprograms = nil;
				@notes = nil;

				super();
			end

			def at(time, **options, &block)
				@latest_note_time = time;

				options[:sequence] = SheetSequence if options[:sheet]

				if prog = options[:sequence]
					options[:slope] ||= 1
					options[:top_slope] = @slope

					prog = prog.new(time, options[:slope], **options)

					i = @subprograms.bsearch_index { |s| s.parent_start_time > prog.parent_start_time }
					@subprograms.insert((i || -1), prog);

					return
				end

				new_event = {
					time: time,
					code: block,
					instance: self,
				}

				i = @notes.bsearch_index { |e| e[:time] > time }
				@notes.insert((i || -1), new_event);
			end

			def after(time, **options, &block)
				at(time + (@latest_note_time || 0) , **options, &block);
			end

			def overload_append_events(collector)
				i = 0
				loop do
					next_program = @subprograms[i]
					break if next_program.nil?
					break if collector.event_time &&
								(collector.event_time < next_program.parent_start_time)

					next_program.append_events collector

					if next_program.state == :torn_down
						@subprograms.delete_at i
					else
						i += 1
					end
				end

				i = @notes.bsearch_index { |e| e[:time] > collector.start_time }
				return unless i

				note_time = @notes[i][:time]

				next_note = @notes[i];
				loop do
					collector.add_event next_note;

					next_note = @notes[i += 1]
					break unless next_note
					break if next_note[:time] != note_time
				end
			end
		end
	end
end
