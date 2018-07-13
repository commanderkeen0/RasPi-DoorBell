#!/bin/bash
#
# Philipp Griessler
# http://www.onemanarmy.biz
#
# central functions for the ringer
# 
#
# Verison 0.1

# SET basic parameters
source /opt/doorbell/door.cfg

function PLAYLOCALSOUND {

# If random Sound is selected
if [[ $RSD -eq 1 ]]
 then
  #SOUND=$(ls $BASEDIR/MP3 | shuf -n 1)
  SOUND=$(find $BASEDIR/MP3 -type f -name "*.mp3" | shuf -n 1)

fi

# If a song is already playing kill the app and restart
#
 pkill $SOUNDBIN 2> /dev/null
 $SOUNDBIN -q -g 100 $SOUND &

}

function KILLLOCALSOUND {
 
 pkill $SOUNDBIN 2> /dev/null

 }

function PLAYREMOTESOUND {

# execute remote host playing
# example ping -c 1 -W 1 192.168.188.252 | grep packet | awk '{ print $6 }'
if [[ $(ping -c 1 -W 1 -q $REMOTE | egrep -o "[0-9]{1,3}%" | sed -s 's/%//g' ) -eq 0 ]]
 then
 	# DEBUG Connection
	if [[ $DEBUG -eq 1 ]]
	then
	 echo "DEBUG: ALIVE !! - CLIENT-IP: $REMOTE - Port: $SSHPORT - ID-FILE: $IDENT - USER: $SSHUSR"
	fi
 ssh -p $SSHPORT -i $IDENT $SSHUSR@$REMOTE -o ConnectTimeout=$SSHTO "pkill $SOUNDBIN"
 sleep 1
 ssh -p $SSHPORT -i $IDENT $SSHUSR@$REMOTE -o ConnectTimeout=$SSHTO "$SOUNDBIN -g 100 $BASEDIR/MP3/$SOUND & > /de/null"
 else
  logger "RING: NO ANSWER - CLIENT-IP: $REMOTE -Port: $SSHPORT - ID-FILE: $IDENT - USER: $SSHUSR"
fi
}

function KILLREMOTESOUND {

# execute remote host playing
if [ $(ping -c 1 -W 1 -q $REMOTE | egrep -o "[0-9]{1,3}%" | sed -s 's/%//g' ) -eq 0 ]
 then
	# DEBUG Connection
	if [[ $DEBUG -eq 1 ]]
	then
	 echo "DEBUG: ALIVE !! - CLIENT-IP: $REMOTE - Port: $SSHPORT - ID-FILE: $IDENT - USER: $SSHUSR"
	fi
  ssh -p $SSHPORT -i $IDENT $SSHUSR@$REMOTE -o ConnectTimeout=$SSHTO "pkill $SOUNDBIN"
   else
  logger "RING: NO ANSWER - CLIENT-IP: $REMOTE -Port: $SSHPORT - ID-FILE: $IDENT - USER: $SSHUSR"
fi
}

function SENDTELEGRAM() {

# create current Date
DATE_EXEC="$(date "+%d %b %Y %H:%M")"

# create static Message
	TEXT="$DATE_EXEC: THE DOORBELL RANG!"

# send information to the groupchat
	curl -i -X GET "https://api.telegram.org/bot$KEY/sendMessage?chat_id=$GRPID&text=$TEXT"

# If the picture option is enable send the picture to the telegram group
if [[ $TBEPIX -eq 1 ]]
 then
	fswebcam -r $RESOLUTION $PIX
	curl -s -X POST "https://api.telegram.org/bot$KEY/sendPhoto" -F chat_id=$GRPID -F photo="@$PIX"
fi
}
