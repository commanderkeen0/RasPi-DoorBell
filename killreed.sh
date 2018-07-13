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
  echo "DEBUG: SCRIPT START: $BASEDIR/$BASENAME - GPIO DEFINED: $DCKSPIN"
fi

# Start infinite loop to monitor the GPIO
while true;
  do
	# set GPIO to input
	gpio -1 mode $DCKSPIN in
	# Read GPIO value
	GPIOREED="$( gpio -1 read $DCKSPIN )"

	# DEBUG
	if [ $DEBUG -eq 1 ]
	 then
	  echo "DEBUG: GPIO DEFINED: $DCKSPIN - GPIO Value: $GPIOREED - DOOR CLOSED: $DOCL"
	fi


	# Compare red value if door is open (0) or closed (1)
	# Compare if door close value is 1
	# Once both
	if [ "$GPIOREED" = "0" ] && [ "$DOCL" = "1" ];
	 then

	  # DEBUG
	  if [ $DEBUG -eq 1 ]
	   then
	    echo "REED SWITCH OPEN"
	  fi

	  # create SYSLOG event
	  logger "RING: KILL BY OPENING DOOR"

	  # START PLAYING SOUND
	  KILLLOCALSOUND

	  # SET DOOR CLOSE VARIABLE to 0 (ZERO)
	  DOCL=0

    fi

	if [ "$GPIOREED" = "1" ]; 
	 then
	  #  RESET DOOR CLOSE VARIABLE
	  DOCL=1
	fi

 sleep 1
done
