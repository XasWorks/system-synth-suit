
$coordinate_def ||= {
	x: 0,
	y: 1,
}

module TEF
	module Animation
		class Coordinate
			$coordinate_def.each do |c, id|
				define_method(c.to_s) do
					@animatable_attributes[c]
				end

				define_method("#{c}=") do |arg|
					if arg.is_a? Numeric
						@animatable_attributes[c].add = arg
					else
						@animatable_attributes[c].from = arg
					end
				end
			end

			def initialize(start_offset)
				@animatable_attributes = {}

				$coordinate_def.each do |key, v|
					@animatable_attributes[key] = Value.new(v + start_offset)
				end
			end

			def animatable_values
				@animatable_attributes.values
			end
		end
	end
end
