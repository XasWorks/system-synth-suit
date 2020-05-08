

module TEF
	module ProgramSelection
		class ID
			attr_reader :title
			attr_reader :groups
			attr_reader :variant

			attr_reader :hash

			def initialize(title, groups, variant)
				@title = title;
				@groups = groups.sort
				@variant = variant

				@hash = @title.hash ^ @groups.hash ^ @variant.hash
			end

			def ==(other)
				if other.is_a? String
					@title == other
				elsif other.is_a? ID
					return false if @title != other.title
					return false if @variant != other.variant
					return false if @groups != other.groups

					true
				end
			end
			alias eql? ==

			def <=>(other)
				tsort = (@title <=> other.title)
				return tsort unless tsort.zero?

				gsort = (@groups <=> other.groups)
				return gsort unless gsort.zero?

				@variant <=> other.variant
			end

			def get_scoring(group_weights)
				score = 0;

				@groups.each do |g|
					if weight = group_weights[g]
						score += weight
					end
				end

				score
			end
		end
	end
end
