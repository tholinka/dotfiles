#!/bin/sh

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "Scans image from printer and outputs to specified file"
	echo "export SSHAUTH as user@ip to use that server, and RSYNCLOC as location to sync file to, defaults to ~/windows_home_dir or ~ if that doesn't exist"
fi

if type tempfile &>/dev/null; then
	TMPFILE="$(tmpfile).png"
elif type mktemp &>/dev/null; then
	TMPFILE="$(mktemp).png"
else
	TMPFILE="/tmp/scanned-image.png"

	echo "No way to create tempfile, as both tempfile and mktemp commands don't exist, so falling back to $TMPFILE"
fi

if [ -z ${SSHAUTH+x} ]; then
	SSHAUTH="p1.printers.local"
fi

if [ -z "$RSYNCLOC" ]; then
	# is there a symlink to the windows home dir? use that
	if [ -d "$HOME/windows_home_dir" ]; then
		RSYNCLOC="$HOME/windows_home_dir/Desktop"
	else
		# use $HOME
		RSYNCLOC="$HOME/"
	fi
fi

echo "Running scanimage on $SSHAUTH with file of $TMPFILE"
ssh -t "$SSHAUTH" "scanimage --format=png > $TMPFILE"

echo "Rsyncing $TMPFILE from $SSHAUTH to $RSYNCLOC"

rsync "$SSHAUTH":"$TMPFILE" "$RSYNCLOC"

echo "Removing $TMPFILE on $SSHAUTH"
ssh -t "$SSHAUTH" "rm $TMPFILE"
