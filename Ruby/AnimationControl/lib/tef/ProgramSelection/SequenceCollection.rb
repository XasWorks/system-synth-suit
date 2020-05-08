
require_relative '../Sequencing/SheetSequence.rb'
require_relative 'ProgramID.rb'

module TEF
	module ProgramSelection
		class SequenceCollection
			attr_reader :sheet_opts

			def self.current_collection
				@current_collection
			end
			def self.current_collection=(n_collection)
				@current_collection = n_collection
			end

			def initialize(program_selector, sequence_runner)
				@program_selector = program_selector
				@sequence_runner = sequence_runner

				@known_programs = {}
				@sheet_opts = {}

				self.class.current_collection = self
			end

			def [](key)
				@known_programs[key]
			end
			def []=(key, n_program)
				key = @program_selector.register_ID key
				@known_programs[key] = n_program
			end

			def play(key)
				prog = @known_programs[key]
				return unless prog

				prog_key = prog.program_key if prog.is_a? ProgramSheet

				if prog.is_a? Sequencing::Sheet
					opts = @sheet_opts[key] || {}
					opts[:sheet] = prog

					prog = Sequencing::SheetSequence.new(Time.now(), 1, **opts)
				end
				prog_key ||= self

				@sequence_runner[prog_key] = prog
			end
		end

		class ProgramSheet < TEF::Sequencing::Sheet
			attr_accessor :program_key

			def initialize()
				super()

				yield(self) if block_given?
			end

			## TODO Give option to add multiple keys with options-hash

			def add_key(title, groups = [], variation = '.mp3')
				prog_collection = SequenceCollection.current_collection
				raise "No program collection was instantiated yet!" unless prog_collection

				id = ID.new(title, groups, variation)

				prog_collection[id] = self
			end
		end
	end
end
