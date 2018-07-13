#!/bin/bash
#
# Philipp Griessler
# http://www.onemanarmy.biz
#
# Using an internal push button switch to stop playing
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
if [ $DEBUG -eq 1 ]
 then
  echo "DEBUG: SCRIPT START: $BASEDIR/$BASENAME - GPIO DEFINED: $KPBSPIN"
fi
 
# Start infinite loop to monitor the GPIO
while true;
  do
	# listen on the defined GPIO PIN
	gpio -1 mode $KPBSPIN in
	gpio -1 wfi $KPBSPIN both
	
	# DEBUG
	if [ $DEBUG -eq 1 ]
     then
	  echo "DEBUG: KILL BUTTON SWITCH PRESSED: GPIO: $KPBSPIN"
	fi
	
	# create SYSLOG event
	logger "RING: KILL PUSH BUTTON SWITCH PRESSED"

	# START PLAYING SOUND
	KILLLOCALSOUND
	
	# set a waiting period before an other signal is accepted from the push button switch
	sleep 3
	
done	