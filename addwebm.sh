# Check that exactly one argument was given to this script
if [ "$#" -ne 1 ]; then
	echo "Usage: ./addwebm.sh <Full root path of lecture folders>"
	exit 1
fi

# Get the path of all the video.mp4 files under the root
lectureRoot=$1
#FILES=$(find $lectureRoot -iname 'video.mp4' | sort -d)
FILES=$(find $lectureRoot -iname 'video.mp4')

for vid in $FILES; do
	# Get the directory that the video.mp4 file is located in
	dir=$(dirname $vid)
	# Try to find corresponding video.webm
	if [ -z "$(find $dir -iname video.webm)" ]; then
		# Webm video not found, so add it
		echo "Converting $vid"
		ffmpeg -i $dir/video.mp4 -c:v libvpx -crf 10 -b:v 200k -c:a libvorbis $dir/video.webm > /dev/null 2>&1
		STATUS=$?
		# Verify that FFmpeg successfully converted
		if [ "$STATUS" = 0 ]; then
			echo "Success!"
		else
			echo "Conversion of $vid failed"
			rm "$dir/video.webm"
		fi
	fi
done
