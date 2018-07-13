#!/bin/bash
#
# Philipp Griessler
# http://www.onemanarmy.biz
#
# This script controls the push button switch behaviour
#
#
# Verison 0.1

# SET basic parameters
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASENAME="$(basename $0)"

# SET basic parameters
source $BASEDIR/door.cfg

# include functions
source $BASEDIR/function.sh

# DEBUG SCRIPT START
if [[ $DEBUG -eq 1 ]]
 then
  echo "DEBUG: SCRIPT START: $BASEDIR/$BASENAME - GPIO DEFINED: $RPBSPIN - TELEGRAM: $TELEGRAMBOT - REMOTE: $REM"
fi

# Start infinite loop to monitor the GPIO
while true;
  do
	# listen on the defined GPIO PIN
	gpio -1 mode $RPBSPIN in
	gpio -1 wfi $RPBSPIN both

	# DEBUG
	if [[ $DEBUG -eq 1 ]]
     then
	  echo "DEBUG: PUSH BUTTON SWITCH PRESSED: GPIO: $RPBSPIN"
	fi

	# create SYSLOG event
	logger "RING: PUSH BUTTON SWITCH PRESSED"

	# START PLAYING SOUND
	PLAYLOCALSOUND


	# Create TELEGRAM message and send to the corresponding group
	if [[ $TELEGRAMBOT -eq 1 ]]
	  then
		# DEBUG
		if [[ $DEBUG -eq 1 ]]
		 then
		  echo "DEBUG: SEND TELEGRAM MESAGE! Picture enabled: $TBEPIX  "
		fi

	  SENDTELEGRAM $TBEPIX
	fi

	# START Remote play
    if [[ $REM -eq 1 ]]
     then
	  PLAYREMOTE
	fi


# set a waiting period before an other signal is accepted from the push button switch
 sleep 2
done
