
require_relative 'Override.rb'

module TEF
	module ParameterStack
		class Stack
			attr_reader :changes
			attr_reader :active_overrides

			def initialize()
				@current_values   = {}
				@active_overrides = {}

				@changes = {}

				@override_list_mutex = Mutex.new()
				@override_list = []

				@recompute_blocks    = []
				@value_change_blocks = []

				@default_override = Override.new(self, -1);
			end

			def [](key)
				@current_values[key]
			end
			def []=(key, value)
				@default_override[key] = value
			end
			def keys
				@current_values.keys
			end

			def on_recompute(*keys, &block)
				@recompute_blocks << {
					block: block,
					keys: keys
				}
			end

			def on_change(*filters, &block)
				filters = nil if filters.empty?

				@value_change_blocks << {
					block: block,
					filters: filters
				}
			end

			private def mark_key_change(key)
				@changes[key] = true

				@recompute_blocks.each do |block_cfg|
					next unless block_cfg[:keys].include? key
					block_cfg[:block].call(key, @current_values[key])
				end
			end

			def override_claims(override, key)
				return if !(@active_overrides[key].nil?) && (@active_overrides[key] > override)

				@active_overrides[key] = override;
				value = override[key];

				return if @current_values[key] == value

				@current_values[key] = value
				mark_key_change key
			end

			def recompute_single(key)
				old_value = @current_values[key]

				found_override = false;

				@override_list_mutex.synchronize do
					@override_list.each do |override|
						next unless override.include? key

						@active_overrides[key] = override;
						@current_values[key]   = override[key];

						found_override = true;

						break;
					end
				end

				if !found_override
					@current_values.delete key
					@active_overrides.delete key
				end

				mark_key_change key if old_value != @current_values[key]
			end

			def recompute(keys)
				keys.each do |key|
					recompute_single key
				end
			end

			private def keys_match_filters(keys, filters)
				return true if filters.nil?

				filters = [filters] unless filters.is_a? Array

				filters.each do |filter|
					keys.each do |key|
						return true if filter.is_a?(Regexp) && key =~ filter
						return true if filter.is_a?(String) && key == filter
					end
				end

				return false
			end

			def process_changes()
				change_list = @changes.keys

				@value_change_blocks.each do |block_cfg|
					next unless keys_match_filters change_list, block_cfg[:filters]

					block_cfg[:block].call()
				end

				@changes = {}
			end

			def add_override(override)
				@override_list_mutex.synchronize do
					@override_list << override unless @override_list.include? override
					@override_list.sort!
				end
			end

			def remove_override(override)
				return unless @override_list.include? override

				@override_list_mutex.synchronize do
					@override_list.delete override
				end

				recompute override.keys
			end
		end
	end
end
