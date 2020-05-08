

def split_fade(fname, oname, start, duration, fades)
	`rm #{oname}`
	`ffmpeg -i #{fname} -ss #{start} -t #{duration} -af 'afade=in:st=#{start}:d=#{fades},afade=out:st=#{start+duration-fades}:d=#{fades}' #{oname}`
end


30.times do |i|
	split_fade("~/Downloads/Hollow_Knight_OST_-_Crystal_Peak\[Youtubemp3.download\].mp3", "crystal_peak-#{100+i}.mp3", 8*i, 9.4, 1.4)
end
