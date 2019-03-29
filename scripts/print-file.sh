#!/bin/sh

if [ -z "$SSHAUTH" ]; then
	SSHAUTH="p1.printers.local"
fi

if [ -z "$PRINTER" ]; then
	PRINTER="Dell_B1165nfw_Mono_MFP"
fi

if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "This script requires the file being printed to be provided on the commandline to print"
	echo "Optionally set SSHAUTH as the user@ip to ssh to, and PRINTER as the name of the printer"
	echo "These default to $SSHAUTH and $PRINTER respectively"
	echo "Usage: $0 file.txt"
	exit 1
fi

TMPFILE=$(tempfile).png

#echo "Running scanimage on $SSHAUTH with file of $TMPFILE"
#ssh -t $SSHAUTH "scanimage --format=png > $TMPFILE"

echo "Rsyncing "$1" to "$SSHAUTH""

rsync "$1" $SSHAUTH:"$TMPFILE"

ssh -t $SSHAUTH "lp -c -d \"$PRINTER\" $TMPFILE"

echo "Removing $TMPFILE on $SSHAUTH"
ssh -t $SSHAUTH "rm $TMPFILE"
