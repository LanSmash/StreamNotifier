
# Built off of mon.sh by Webberist

# TWITCH.TV/OSX USE ONLY
# Constantly looping - 30 second break in between. Takes the streams given via arguments and checks if each is up.
# Will alert all the comma-seperated contacts defined below via iMessage if possible.
# If an alert is sent, once that iteration of checks is done the program will sleep
# for 5 minutes to give time for get the stream back up

# Will also check if the internet connection is alive or if the Twitch API is cooked.

# Usage: Want to check on twitch.tv/riotgames, twitch.tv/b0aty, twitch.tv/lirik
# ./streams.sh riotgames b0aty lirik

CONTACTS="someone@email.com,0435216###,someoneelse@email.com"
if [ -z "$*" ]
then
	echo "Need some streams to look for. Eg: './streamsMonitorLoop.sh riotgames summit1g lirik'"
	exit 0
fi	
	while true; do
		DOWNALERT="FALSE"
		for var in "$@"
		do
			echo "Checking stream: $var"
			OUTPUT={`curl -s -H 'Accept: application/vnd.twitchtv.v2+json' -X GET https://api.twitch.tv/kraken/streams/$var | python -mjson.tool | grep stream`} &> /dev/null
			if [[ $OUTPUT == *"null"* ]]
			then
				echo "$var is down!"
				imessage -t "STREAM: twitch.tv/$var is possibly down!" -c $CONTACTS
				DOWNALERT="TRUE"
				echo "ALERTS SENT"
			else
				if [[ $OUTPUT == *"{}"* ]]
				then
					#is the internet connection down?
					PING=$(nc -z 8.8.8.8 53) &> /dev/null
					if [[ $PING == *"succeeded"* ]]
					then
						echo "Twitch API cooked?"
						continue
					else
						echo "INTERNET IS POSSIBLY DOWN"
						continue
					fi
				fi
				echo "$var is up!"
			fi
		done
		if [[ $DOWNALERT == "FALSE" ]]
		then
			echo "Sleeping for 30s"
			sleep 30
		else
			echo "Sleeping for 5m to give time to fix."
			sleep 300
		fi
	done
exit 0
