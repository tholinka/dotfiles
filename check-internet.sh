#!/bin/bash

if type tempfile &>/dev/null; then
	tmp="$(tempfile)"
elif type mktemp &>/dev/null; then
	tmp="$(mktemp)"
else
	tmp="/tmp/check-internet"

	echo "No way to create temp file, as both tempfile and mktemp commands don't exist, so falling back $tmp" | tee $tmp
fi

date_format="+%_I:%M:%S %p %_m /%_d"

router_down=""
dns_down=""
modem_down=""

one_down=""
nine_down=""
interval=10

if [ -n "$1" ]; then
	case $1 in
		*h*)
			echo "Usage: $0 seconds"
			echo "Where seconds optionally sets how long to sleep between pings, defaults to 10"
			exit 0
			shift
		;;
		*)
			interval="$1"
			shift
		;;
	esac
fi

# put in file, but also show on screen
echo "Using sleep interval of $interval" | tee "$tmp"

trap cleanup SIGINT SIGTERM

function ping_test()
{
	if ping -q -c 1 -W 1 "$1" >/dev/null; then
		if ! [ -z "$2" ]; then
			eval "$2=''"
		fi

		echo "UP: $1"
	else
		if ! [ -z "$2" ]; then
			if [ "${!2}" == "" ]; then
				eval "$2='Down since $(date "$date_format")'"
			fi
		fi

		echo "DOWN: $1 - ${!2}"
	fi
}

function do_ping()
{
	ping_test 192.168.1.1 router_down
	ping_test 192.168.1.25 dns_down
	#ping_test "d1.dns.local"
	ping_test 192.168.100.1 modem_down

	echo;

	ping_test 1.1.1.1 one_down
	ping_test 9.9.9.9 nine_down
}

function cleanup()
{
	echo "Removing tmp file: $tmp"
	rm "$tmp"
	exit 0
}

# note: watching a file instead of just directly printing to screen
# because then the display doesn't flicker as lines are printed
# which makes having it in the corner of a monitor much less annoying
watch cat "$tmp" &

# sleep to allow above notifications to be read
sleep 0.5

while true; do
	echo "Time: $(date "$date_format")" > "$tmp"
	echo >> "$tmp"

	do_ping >> "$tmp"

	sleep "$interval"
done
