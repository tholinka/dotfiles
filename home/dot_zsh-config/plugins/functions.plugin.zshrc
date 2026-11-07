FUNCTIONS_FILE_LOC="${(%):-%N}" # hacky workaround to replace bash's export

# until ssh; sleep; done wrapper
function up() {
  until ssh -o ConnectTimeout=1s "$@" 'exit 0'; do echo -n 'sleeping...'; sleep 5; done
}

# grep wrapper that does grep --include "..." --exclude "..." -Rnwi . -e "[pattern]" in an easy function of grephere [pattern] [exclude] [include]
function grephere() {
	# echo "grephere pattern exclude include e.g. grephere \"hello world\" \"*.o\" \"*.{c,h}\""
	if [ -z "$2" ]; then
		exclude=""
	else
		exclude="--exclude=\"$2\ "
	fi

	if [ -z "$3" ]; then
		include=""
	else
		include="--include=$3"
	fi

	echo "searching for \"$1\" with include of \"$2\" and exclude of \"$3\""

	grep $include $exclude -Rnwi . -e $1 || echo "nothing found"
}

function screen() {
	# see if there are any arguments
	if [ -z "$@" ]; then
		# no arguments, quiet screen
		command screen -q
	else
		# treat as a normal screen
		command screen $@
	fi

	# if screen exited badly display notification (e.g. it does on ubuntu subsystem for windows)
	if ((?)); then
		echo "Screen Failed"
	fi
}

function psgrep() {
    ps auxww | grep -i -e "$@" | grep -v -e "grep -i -e "$@""
}

# some sites that support curl
if (( $+commands[curl] )); then
	function weather() {
		curl -s https://wttr.in/"$1"
	}
	function cheat() {
		curl -s https://cheat.sh/"$1"
	}
	function publicip() {
		curl -s https://ifconfig.co/"$1"
	}
	function qrcode() {
		curl -s -F"-=$1" https://qrenco.de
	}
	function dictionary() {
		curl -s dict://dict.org/d:"$1"
	}
	function crypto() {
		curl -s https://rate.sx/"$1"
	}
	function shorturl() {
		curl -F"shorten=$1" https://0x0.st
	}
	function news() {
		curl getnews.tech/"$1"
	}
fi

if (( $+commands[runelite] )); then
	# don't pollute ~ with runescape's files - probably edit this into /usr/bin/runelite so you can start it from your DE's launcher
	function runelite() {
		RL_DIR="/home/$USER/.config/runelite"

		if [ -z _JAVA_OPTIONS ] ; then
			RUNELITE_JAVA_OPTIONS="-Duser.home=\"$RL_DIR\""
		else
			RUNELITE_JAVA_OPTIONS="$_JAVA_OPTIONS -Duser.home=\"$RL_DIR\""
		fi

		if (( $+commands[prime-run] )); then
			env _JAVA_OPTIONS="$RUNELITE_JAVA_OPTIONS" prime-run runelite
		else
			env _JAVA_OPTIONS="$RUNELITE_JAVA_OPTIONS" runelite
		fi

		unset RUNELITE_JAVA_OPTIONS
	}
fi

# WSL specific things
if (( $+commands[wslpath] )); then # WSL
	if (( $+commands[cmd] )); then
		cmd="$(which cmd)"
		function cmd() (
			# cmd absolutely hates starting in a UNC (aka network) path and WILL alert you about it at every possible chance
			cd "$(wslpath 'C:\')" && "$cmd" "$@"
		)
	fi

	if (( $+commands[code] )); then
		code="$(which code)"

		# we're running code.exe (to prevent announces, like updating at startup), instead of the shell script code ships with
		# so we need to do a few things the shell script does for us
		function code() {
			a=()

			for var in "$@"
			do
				case "$var" in
				-*) ;;                              # Leave command-line options alone
				/*) ;;                              # Leave absolute paths alone
				*) rp=$(realpath -s "$var");
					[[ -n "$rp" ]] && var="$rp" ;;  # replace relative paths with absolute
				esac
				a+=("$var")
			done

			$code --remote "wsl+$WSL_DISTRO_NAME" "${a[@]}" &>/dev/null &
		}
	fi
fi

# set open if 1) not present (e.g. not mac) and 2) we have some way of opening apps (xdg-open, powershell.exe, etc)
if (( ! $+commands[open] )); then
	# prefer xdg-open
	if (( $+commands[xdg-open] )); then # linux
		alias open="xdg-open"
	elif (( $+commands[powershell] )); then # WSL
		function open() {
			"$BROWSER" "$@"
		}
	fi
fi
