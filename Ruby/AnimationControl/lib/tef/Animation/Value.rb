

module TEF
	module Animation
		class Value
			attr_reader :ID

			attr_reader :module_id

			def initialize(value_num)
				@ID = value_num;

				@current = Hash.new(0);
				@changes = {}

				@is_animated = false;
			end

			def module_id=(new_id)
				@module_id = new_id

				[:add, :multiply, :dampen, :delay, :from, :jump, :velocity].each do |key|
					@changes[:key] = true if @current[key] != 0
				end
			end

			def total_id()
				"#{@module_id}V#{@ID.to_s(16)}"
			end

			[:jump, :velocity, :add, :multiply, :dampen, :delay].each do |key|
				define_method(key.to_s) do
					@current[key]
				end

				define_method("#{key}=") do |input|
					raise ArgumentError, "Input must be numeric!" unless input.is_a? Numeric

					return if (input == @current[key] && ![:jump, :velocity].include?(key))

					if [:multiply, :dampen, :delay].include? key
						@is_animated = true
					end

					@current[key] = input
					@changes[key] = true
				end
			end

			def from() return @current[:from] end

			def from=(target)
				if target.is_a? Value
					target = target.total_id
				end

				if target.nil?
					target = 'S0M0V0'
				end

				unless target =~ /^S[\d]{1,3}M[\da-f]{1,3}V\d+$/
					raise ArgumentError, 'Target must be a valid Animation Value'
				end

				return if target == @current[:from]

				@current[:from] = target
				@changes[:from] = true
				@is_animated = true
			end

			def has_changes?
				return !@changes.empty?
			end

			private def rcut(value)
				value.to_s.gsub(/(\.)0+$/, '')
			end

			def set_string()
				return nil unless has_changes?

				if !@is_animated
					return nil unless @changes[:add]

					out_str = "J#{rcut(@current[:add])};"

					@changes = {}

					return out_str
				end

				out_str = [];

				out_str << "J#{rcut(@current[:jump])}" if @changes[:jump]
				out_str << "V#{rcut(@current[:velocity])}" if @changes[:velocity]

				out_str << @current[:from] if @changes[:from]

				config_strs = [];
				config_strs_out = [];
				[:add, :multiply, :dampen, :delay].each do |k|
					config_strs << rcut(@current[k])

					config_strs_out = config_strs.dup if @changes[k]
				end

				@changes = {}

				(out_str + config_strs_out).join(' ') + ';'
			end
		end
	end
end
