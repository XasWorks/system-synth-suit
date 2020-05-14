
require_relative 'Stack.rb'

module TEF
	module ParameterStack
		class Override
			include Comparable

			attr_reader :level

			def initialize(stack, init_level = 0)
				raise ArgumentError, 'Handler must be CoreStack!' unless stack.is_a? Stack

				@stack = stack

				@level = init_level;
				@overrides = {}

				@valid_until = nil;

				@stack.add_override self
			end

			def [](key)
				@overrides[key]
			end

			def []=(key, new_value)
				return if @overrides[key] == new_value
				@overrides[key] = new_value

				@stack.override_claims self, key
			end

			def include?(key)
				@overrides.include? key
			end
			def keys
				@overrides.keys
			end

			def delete(key)
				return unless @overrides.include? key
				@overrides.delete key

				return unless @stack.active_overrides[key] == self

				@stack.recompute_single key
			end

			def destroy!
				@stack.remove_override self
			end

			def <=>(other)
				return @level <=> other.level if other.level != @level
				return self.hash <=> other.hash
			end
		end
	end
end
