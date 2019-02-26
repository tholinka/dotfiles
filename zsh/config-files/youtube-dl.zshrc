# wrap a few youtube-dl commands, e.g. youtube-mp3 [video] and vimeo-password [video] [password]
[[ -v YOUTUBE_DL_OUTPUT_FOLDER ]] ||  YOUTUBE_DL_OUTPUT_FOLDER="$HOME/Downloads/youtube-dl"
[[ -v YOUTUBE_DL_OUTPUT_FILE ]] || YOUTUBE_DL_OUTPUT_FILE="%(title)s.%(ext)s"
[[ -v ${YOUTUBE_DL_OUTPUT+x} ]] || YOUTUBE_DL_OUTPUT="-o$YOUTUBE_DL_OUTPUT_FILE"

function check-youtube-dl-loc()
{
	[[ ! -d "$YOUTUBE_DL_OUTPUT_FOLDER" ]] && mkdir "$YOUTUBE_DL_OUTPUT_FOLDER"
}

function youtube-mp3()
(
	check-youtube-dl-loc

	cd "$YOUTUBE_DL_OUTPUT_FOLDER"

	youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 "$YOUTUBE_DL_OUTPUT" "$@" || echo "Usage: youtube-mp3 VIDEO-URL"
)

function vimeo-password()
(
	check-youtube-dl-loc

	cd "$YOUTUBE_DL_OUTPUT_FOLDER"

	youtube-dl "$1" --video-password "$2" "$YOUTUBE_DL_OUTPUT" "${@:3}" || echo "Usage: vimeo-password VIDEO-URL PASSWORD"
)