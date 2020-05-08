
require 'xasin_logger'

require_relative 'Animatable.rb'

module TEF
	module Animation
		class Handler
			include XasLogger::Mix

			def initialize(furcoms_bus)
				@furcoms = furcoms_bus

				@animation_mutex = Mutex.new
				@active_animations = {}

				@pending_deletions = {}
				@pending_creations = {}

				init_x_log('Animation Handler')

				# TODO REMOVE
				@force_debug = true
			end

			def clean_key(key)
				key = 'S%<S>dM%<M>d' % key if key.is_a? Hash

				unless key =~ /^S[\d]{1,3}M[\d]{1,3}$/
					raise ArgumentError, 'Target must be a valid Animation Value'
				end

				key
			end

			def [](key)
				@active_animations[clean_key key]
			end

			def []=(key, new_obj)
				@animation_mutex.synchronize {
					key = clean_key key

					@active_animations[key]&.module_id = nil;

					if new_obj.nil?
						@pending_deletions[key] = true

					elsif new_obj.is_a? Animatable
						new_obj.module_id = key

						@active_animations[key] = new_obj
						@pending_creations[key] = new_obj.creation_string
					else
						raise ArgumentError, 'New animation object is of invalid type'
					end
				}
			end

			private def join_and_send(topic, data)
				return if data.empty?

				out_str = '';
				data.each do |str|
					if(out_str.length + str.length > 200)
						@furcoms.send_message topic, out_str
						out_str = ''
					end

					out_str += str
				end

				@furcoms.send_message topic, out_str
			end

			# TODO Replace this with a time-synched system
			# using the main synch time
			private def update_deaths
				death_reconfigs = [];

				@animation_mutex.synchronize {
					@active_animations.each do |key, animation|
						if (!animation.death_time.nil?) && animation.death_time < Time.now()
							@pending_deletions[key] = :silent
						end

						new_death = animation.death_time_string
						next if new_death.nil?

						death_reconfigs << new_death
					end
				}

				deletions = []
				@pending_deletions.each do |key, val|
					deletions << "#{key};" unless val == :silent
					@active_animations.delete key
				end
				@pending_deletions = {}

				join_and_send('DTIME', death_reconfigs)
				join_and_send('DELETE', deletions)
			end

			private def update_creations
				@pending_creations.each do |key, val|
					@furcoms.send_message('NEW', val)
				end

				@pending_creations = {}
			end

			private def optimize_and_send(messages)
				last_change = {}
				out_str = '';
				can_optimize = false

				messages.each do |change|
					opt_string = change[:str]

					can_optimize = false if last_change[:module] != change[:module]
					can_optimize = false if last_change[:value]  != (change[:value] - 1)
					can_optimize = false if (out_str.length + opt_string.length) > 200
					can_optimize = false if opt_string[0] == 'S'

					opt_string = "#{change[:module]}V#{change[:value].to_s(16)} #{opt_string}" unless can_optimize

					if opt_string.length + out_str.length > 200
						@furcoms.send_message 'SET', out_str
						out_str = ''
					end

					out_str += opt_string


					can_optimize = true
					last_change = change
				end

				@furcoms.send_message 'SET', out_str
			end

			private def update_values()
				pending_changes = []

				@animation_mutex.synchronize {
					@active_animations.each do |key, anim|
						pending_changes += anim.get_set_strings
					end
				}

				return if pending_changes.empty?
				x_logd "Pending changes are #{pending_changes}"

				optimize_and_send pending_changes
			end

			private def update_colors
				pending_changes = []
				
				@animation_mutex.synchronize {
					@active_animations.each do |key, anim|
						pending_changes += anim.get_setc_strings
					end
				}

				return if pending_changes.empty?
				x_logd "Pending changes are #{pending_changes}"

				join_and_send 'CSET', pending_changes
			end

			def update_tick()
				update_creations

				update_deaths

				update_values
				update_colors
			end
		end
	end
end
