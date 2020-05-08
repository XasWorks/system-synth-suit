
module TEF
	module Animation
		class Color
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

				[:jump, :velocity, :target, :delay_a, :delay_b].each do |key|
					@changes[:key] = true if @current[key] != 0
				end
			end

			def total_id()
				"#{@module_id}V#{@ID}"
			end

			[:jump, :velocity, :target, :delay_a, :delay_b].each do |key|
				define_method(key.to_s) do
					@current[key]
				end

				define_method("#{key}=") do |input|
					raise ArgumentError, "Input must be numeric!" unless input.is_a? Numeric

					return if ![:jump, :velocity].include?(key) && input == @current[key]

					if [:delay_a, :delay_b].include? key
						@is_animated = true
					end

					@current[key] = input
					@changes[key] = true
				end
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
					return nil unless @changes[:target]

					out_str = "V#{@ID} J#{@current[:target].to_s(16)};"

					@changes = {}

					return out_str
				end

				out_str = ["V#{@ID}"];

				out_str << "J#{@current[:jump].to_s(16)}" if @changes[:jump]
				out_str << "V#{@current[:velocity].to_s(16)}" if @changes[:velocity]

				config_strs = [];
				config_strs_out = [];
				[:target, :delay_a, :delay_b].each do |k|
					if k == :target
						config_strs << @current[k].to_s(16)
					else
						config_strs << rcut(@current[k])
					end

					config_strs_out = config_strs.dup if @changes[k]
				end

				@changes = {}

				(out_str + config_strs_out).join(' ') + ';'
			end
		end
	end
end
