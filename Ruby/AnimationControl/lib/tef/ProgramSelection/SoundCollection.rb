
require_relative 'ProgramSelector.rb'

require 'yaml'

module TEF
	module ProgramSelection
		class SoundCollection
			attr_reader :silence_maps
			attr_reader :soundmap
			attr_reader :load_config

			def initialize(program_handler)
				@handler = program_handler
				@soundmap = {}

				@load_config  = {};
				@silence_maps = {}

				if File.file? './sounds/soundconfig.yml'
					@load_config = YAML.load File.read './sounds/soundconfig.yml'
				end

				if File.file? './sounds/silence_maps.yml'
					@silence_maps = YAML.load File.read './sounds/silence_maps.yml'
				end

				`find ./`.split("\n").each { |fn| add_file fn };

				File.write('./sounds/silence_maps.yml', YAML.dump(@silence_maps));

				@play_pids = {};
			end

			def generate_silences(fname)
				return if @silence_maps[fname]

				ffmpeg_str = `ffmpeg -i #{fname} -af silencedetect=n=0.1:d=0.1 -f null - 2>&1`

				out_event = {}

				ffmpeg_str.split("\n").each do |line|
					if line =~ /silence_start: ([\d\.-]*)/
						out_event[$1.to_f] = 0
					elsif line =~ /silence_end: ([\d\.-]*)/
						out_event[$1.to_f] = 1
					end
				end

				if(out_event.empty?)
					out_event[0.01] = 1
				elsif (k = out_event.keys[0]) < 0
					out_event.delete k
					out_event[0.01] = 0
				else
					out_event[0.01] = 1
				end

				@silence_maps[fname] = out_event
			end

			def add_file(fname)
				rMatch = /^\.\/sounds\/(?<groups>(?:[a-z_]+[\/-])*)(?<title>[a-z_]+)(?<variant>(?:-\d+)?\.(?:ogg|mp3|wav))/.match fname;
				return unless rMatch;

				title = rMatch[:title].gsub('_', ' ');
				groups = rMatch[:groups].gsub('_', ' ').gsub('-','/').split('/');

				groups = ["default"] if groups.empty?

				id = @handler.register_ID(title, groups, rMatch[:variant])

				@soundmap[id] = fname

				generate_silences fname
			end

			def silences_for(key)
				@silence_maps[@soundmap[key]]
			end

			def play(id, collection_id = 'default')
				sound_name = @soundmap[id]
				return if sound_name.nil?

				collection_id ||= id;

				if old_pid = @play_pids[collection_id]
					Process.kill('QUIT', old_pid)
				end

				Thread.new do
					fork_pid = spawn(*%W{play -q --volume 0.3 #{sound_name}});

					@play_pids[collection_id] = fork_pid;
					Process.waitpid fork_pid;
					@play_pids.delete collection_id
				end
			end
		end
	end
end
