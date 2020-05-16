
require_relative 'Value.rb'
require_relative 'Color.rb'
require_relative 'Coordinate.rb'

module TEF
	module Animation
		class Animatable
			attr_reader :module_id
			attr_reader :death_time

			attr_reader :death_delay

			def self.get_attr_list
				@class_attribute_list ||= {}
			end
			def self.get_color_list
				@class_color_list ||= {}
			end
			def self.get_coordinate_list
				@class_coordinate_list ||= {}
			end

			def self.animatable_attr(name, id)
				get_attr_list()[name] = id

				define_method(name.to_s) do
					@animatable_attributes[name]
				end

				define_method("#{name}=") do |arg|
					if arg.is_a? Numeric
						@animatable_attributes[name].add = arg
					else
						@animatable_attributes[name].from = arg
					end
				end
			end

			def self.animatable_color(name, id)
				get_color_list()[name] = id

				define_method(name.to_s) do
					@animatable_colors[name]
				end

				define_method("#{name}=") do |arg|
					@animatable_colors[name].target = arg
				end
			end

			def self.animatable_coordinate(name, start)
				get_coordinate_list()[name] = start

				define_method(name.to_s) do
					@animatable_coordinates[name]
				end
			end

			def initialize()
				@animatable_attributes = {}
				@animatable_colors = {}
				@animatable_coordinates = {}

				self.class.get_attr_list.each do |key, val|
					@animatable_attributes[key] = Value.new(val)
				end

				self.class.get_color_list.each do |key, val|
					@animatable_colors[key] = Color.new(val)
				end

				self.class.get_coordinate_list.each do |key, offset|
					@animatable_coordinates[key] = Coordinate.new(offset)
				end
			end

			def death_time=(n_time)
				raise ArgumentError, 'Must be a Time!' unless n_time.is_a? Time || n_time.nil?

				return if n_time == @death_time

				@death_time = n_time
				@death_time_changed = true
			end

			def die_in(t)
				if t.nil?
					self.death_time = nil
					@death_delay = nil

					return
				end

				raise ArgumentError, "Time must be num!" unless t.is_a? Numeric

				self.death_time = Time.now() + t
				@death_delay = t
			end

			def die!
				self.death_time = Time.at(0)
			end

			def configure(h = nil, **opts)
				h ||= opts;

				raise ArgumentError, 'Config must be a hash!' unless h.is_a? Hash

				h.each do |key, data|
					value = 	@animatable_attributes[key] ||
								@animatable_colors[key] ||
								@animatable_coordinates[key]

					raise ArgumentError, "Parameter #{key} does not exist!" unless value

					value.configure(data);
				end
			end

			def creation_string
				""
			end

			def all_animatable_attributes
				out =  @animatable_attributes.values
				out += @animatable_coordinates.values.map(&:animatable_attributes)

				out.flatten
			end

			def module_id=(new_str)
				unless new_str =~ /^S[\d]{1,3}M[\d]{1,3}$/ || new_str.nil?
					raise ArgumentError, 'Target must be a valid Animation Value'
				end

				all_animatable_attributes.each do |value|
					value.module_id = new_str
				end

				die_in @death_delay if @death_delay

				@module_id = new_str
			end

			def death_time_string
				return nil unless @death_time_changed

				@death_time_changed = false

				return "#{@module_id} N;" if @death_time.nil?

				remaining_time = (@death_time - Time.now()).round(2)

				"#{@module_id} #{remaining_time};"
			end

			def get_set_strings()
				return [] unless @module_id

				out_elements = []

				all_animatable_attributes.each do |val|
					o_str = val.set_string
					next if o_str.nil?

					out_elements << { module: @module_id, value: val.ID, str: o_str };
				end

				out_elements
			end

			def get_setc_strings()
				return [] unless @module_id

				out_elements = []

				@animatable_colors.values.each do |val|
					o_str = val.set_string
					next if o_str.nil?

					out_elements << "#{@module_id}#{o_str}"
				end

				out_elements
			end
		end

		class Box < Animatable
			animatable_color :color, 0

			animatable_attr :rotation, 0
			animatable_attr :up, 1
			animatable_attr :down, 2
			animatable_attr :left, 3
			animatable_attr :right, 4

			animatable_coordinate :x_dir, 0xC000
			animatable_coordinate :y_dir, 0xC100
			animatable_coordinate :center, 0xC200

			def initialize(layer_no = 0)
				super();

				@layer = layer_no;
			end

			def creation_string
				"BOX #{@module_id} #{@layer}"
			end
		end
	end
end
