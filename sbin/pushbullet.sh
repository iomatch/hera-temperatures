#/bin/bash
# get your Access Token with the code from Pushbullet.com
# and write it to etc/conf/pushbullet.sh.conf
# create a link of this file to /usr/bin
myNameIs=${0##*/}
myPathIs=${0%/*}
[ -z "$debug" ] && debug=0
[ "$debug" -gt "0" ] && logger "$myNameIs :: $myPathIs/$myNameIs, \$debug: $debug"
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
if [ -r "$pbAPIkeyFile" ]; then
	API=$(head -1 $pbAPIkeyFile|tr -d '[[:space:]]') || myDie "File ($pbAPIkeyFile) containing the Access Token needed for PushBullet cannot be read. Unable to continue."
else
	myDie "Access Token key file ($pbAPIkeyFile) not found."
fi

# Check taht we have the Access Token as $API from $pbAPIkeyFile
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

#[ ! -z "$1" ] && curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="$title" -d body="$MSG" > /dev/null 2>&1 || echo "No message. Exiting."
if [ ! -z "$MSG" ]; then
	if [ "$debug" -gt "0" ]; then
		#logger "$myNameIs :: Sent PushBullet :: $MSG"
		logger " "
		logger "     pushpushpushpushpushpushpushpushpushpushpushpushpushpushpushpushpushpushpush"
		logger "     u                                                                          h"
		logger "     s  I am pushbullet.sh, the PushBullet shell script to send notifications.  s"
		logger "     h                                                                          u"
		logger "     hsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsuphsup"
		logger " "
		logger "My message is:"
		logger "$MSG"
		logger " "
	fi
	curl -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="$title" -d body="$MSG" > /dev/null 2>&1
else
	[ "$debug" -gt "0" ] && logger "$myNameIs :: No message, no PushBullet. Exiting."
	#echo "No message. Exiting."
fi
