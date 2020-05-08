
require_relative 'ProgramID.rb'

module TEF
	module ProgramSelection
		class Selector
			attr_accessor :group_weights

			def initialize()
				@known_programs = {} # Hash based on titles
				@known_groups = {}

				@group_weights = {}
			end

			def register_ID(program, pgroups = [], pvariant = nil)
				if program.is_a? String
					program = ID.new(program, pgroups, pvariant)
				end

				proglist = (@known_programs[program.title] ||= [])

				if found_prog = proglist.find { |prg| prg == program }
					return found_prog
				end

				proglist << program

				program.groups.each { |group| @known_groups[group] = true }

				program
			end

			def fetch_ID(title, group_weights = {})
				return nil if @known_programs[title].nil?

				weights = @group_weights.merge(group_weights)

				current_best = nil;
				current_list = [];

				@known_programs[title].each do |prg|
					p_score = prg.get_scoring(weights);
					current_best ||= p_score

					next if current_best > p_score

					if current_best == p_score
						current_list << prg
					else
						current_best = p_score
						current_list = [prg]
					end
				end

				current_list.sample
			end

			def fetch_string(str)
				title, groups = str.split(" from ");
				groups ||= "";
				groups = groups.split(" and ").map { |g| [g, 2] }.to_h

				fetch_ID(title, groups)
			end

			def all_titles()
				@known_programs.keys
			end

			def all_groups()
				@known_groups.keys
			end
		end
	end
end
