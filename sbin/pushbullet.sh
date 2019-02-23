#!/bin/bash
# v.1.1.0
# get your Access Token with the code from Pushbullet.com
# and write it to etc/conf/pushbullet.sh.conf
# create a link of this file to /usr/bin
myNameIs=${0##*/}
myPathIs=${0%/*}

debug=1

[ -z ${debug+x} ] && debug=0
if [ "$debug" -gt "0" ]; then
	logger -i " I am $myNameIs, the PushBullet shell script to send notifications. "
fi
#logger "$myNameIs :: $myPathIs/$myNameIs, \$debug: $debug"
#logger "$myNameIs :: $myPathIs/$myNameIs, \$debug: $debug"
baseName=$(basename $myNameIs)

myDie() {
	msg="$1 Die."
	logger "$myNameIs :: $msg"
	#echo "$msg"
	exit 1
}

[ -z "$1" ] && myDie "No message."

# Set the API key file location
pbAPIkeyFile="/usr/local/etc/conf/"$baseName".conf"

# Check if $pbAPIkeyFile is readable by user
# and myDie() if not
[ "$debug" -gt "0" ] && logger "$myNameIs :: Checking for file containing the API key..."
if [ -r "$pbAPIkeyFile" ]; then
	API=$(head -1 $pbAPIkeyFile|tr -d '[[:space:]]') && logger "$myNameIs :: API key found." || myDie "File ($pbAPIkeyFile) containing the Access Token needed for PushBullet cannot be read. Unable to continue."
else
	myDie "Access Token key file ($pbAPIkeyFile) not found."
fi

# Check that we have the Access Token as $API from $pbAPIkeyFile
# or myDie() trying...
[ -z "$API" ] && myDie "No Access Token found at $pbAPIkeyFile."

# Checks done. Script is ready to run.
[ -f "/etc/os-release" ] && . /etc/os-release
[ ! -z "$PRETTY_NAME" ] && os=$PRETTY_NAME || os=$(uname -srmo)

MSG="$1"

if [ -z "$2" ]; then
        title=$(hostname)" [$os]"
else
        title=$2
fi

[ "$debug" -gt "0" ] && logger "$myNameIs :: Compiled push message:"
[ "$debug" -gt "0" ] && logger "$myNameIs :: [ title ]: $title"
[ "$debug" -gt "0" ] && logger "$myNameIs :: [  msg  ]: $MSG"

sndDt="$(date +'%d.%m.%y %H:%M.%S')"

MSG=$MSG" [log date: $sndDt]"
if [ ! -z "$MSG" ]; then
	if curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="$title" -d body="$MSG" > /dev/null 2>&1; then
		logger "$myNameIs :: Push notification sent successfully."
	else
		logger "$myNameIs :: Problem sending push notification."
	fi
else
	[ "$debug" -gt "0" ] && logger "$myNameIs :: No message, no PushBullet. Exiting."
fi
