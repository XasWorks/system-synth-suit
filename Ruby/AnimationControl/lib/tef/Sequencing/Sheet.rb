

module TEF
	module Sequencing
		class Sheet
			attr_accessor :start_time
			attr_accessor :end_time

			attr_accessor :tempo

			attr_reader :setup_block
			attr_reader :teardown_block

			def initialize()
				@start_time = 0;
				@end_time = nil;

				@tempo = nil

				@setup_block = nil;
				@teardown_block = nil;
			end

			def sequence(&block)
				@setup_block = block;
			end

			def teardown(&block)
				@teardown_block = block;
			end
		end
	end
end
