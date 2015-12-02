# contact list is comma seperated list
# eg: CONTACTS="test@example.com,test1@example.com"

CONTACTS="test@example.com,test1@example.com"

#if [ -z "$VAR" ]; && echo "example usage: mon.sh twitch.tv/channel" && exit -1

#monstream () {
	livestreamer \
		--hls-timeout 15 --http-stream-timeout 15 \
		$1 audio --output /dev/null

	TEXT="STREAM: $1 - may be down... at `date`"
	echo sending text: $TEXT

	imessage -t "$TEXT" -c $CONTACTS
#}

