
require_relative 'Animatable.rb'

module TEF
	module Animation
		class Eye < Animatable
			animatable_color :outer_color, 0
			animatable_color :inner_color, 1

			animatable_attr :iris_x, 0x10
			animatable_attr :iris_y, 0x11
			animatable_attr :top, 0x12
			animatable_attr :bottom, 0x13
			animatable_attr :eye_closure, 0x14

			def initialize()
				super();
			end
		end
	end
end
