
require_relative 'ProgramSelector.rb'

module TEF
	module ProgramSelection
		class SoundCollection
			attr_reader :silence_maps

			def initialize(program_handler)
				@handler = program_handler
				@soundmap = {}

				@silence_maps = {}

				`find ./`.split("\n").each { |fn| add_file fn };

				@play_pids = {};
			end

			def generate_silences(fname, id)
				ffmpeg_str = `ffmpeg -i #{fname} -af silencedetect=n=0.1:d=0.05 -f null - 2>&1`

				out_event = {}

				ffmpeg_str.split("\n").each do |line|
					if line =~ /silence_start: ([\d\.-]*)/
						out_event[$1.to_f] = 0
					elsif line =~ /silence_end: ([\d\.-]*)/
						out_event[$1.to_f] = 1
					end
				end

				if (k = out_event.keys[0]) < 0
					out_event.delete k
					out_event[0] = 0.01
				else
					out_event[0] = 1
				end

				# puts "Silences for #{fname} are #{out_event}"
				#  TODO x_logd

				@silence_maps[id] = out_event
			end

			def add_file(fname)
				rMatch = /^\.\/sounds\/(?<groups>(?:[a-z_]+[\/-])*)(?<title>[a-z_]+)(?<variant>(?:-\d+)?\.(?:ogg|mp3|wav))/.match fname;
				return unless rMatch;

				title = rMatch[:title].gsub('_', ' ');
				groups = rMatch[:groups].gsub('_', ' ').gsub('-','/').split('/');

				groups = ["default"] if groups.empty?

				id = @handler.register_ID(title, groups, rMatch[:variant])

				@soundmap[id] = fname

				generate_silences fname, id
			end

			def play(id)
				sound_name = @soundmap[id]
				return if sound_name.nil?

				Thread.new do
					fork_pid = fork do
						exec("play -q --volume 0.3 #{sound_name}");
					end

					@play_pids[id] = fork_pid;
					Process.waitpid fork_pid;
					@play_pids.delete id
				end
			end
		end
	end
end
