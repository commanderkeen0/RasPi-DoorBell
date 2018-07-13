#!/bin/bash
#
# Philipp Griessler
# http://www.onemanarmy.biz
#
# start the differnet GPIO monitoring scripts and 
# 
#
# Verison 0.1

# SET basic parameters
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASENAME="$(basename $0)"


case $1 in
 start)
	sudo -u pi screen -dmS RINGBELL $BASEDIR/ringbell.sh
	sudo -u pi screen -dmS KILLSWITCH $BASEDIR/killswitch.sh
	sudo -u pi screen -dmS KILLREED $BASEDIR/killreed.sh
#	sudo -u pi /opt/doorbell/wifi_recon.sh
#	screen -ls
 ;;
 stop)
  pkill dringbell.sh
  pkill killswitch.sh
  pkill killreed.sh
  pkill screen
  sleep 5
 # screen -ls
 ;;
 *) 
  echo "usage: start | stop"
 esac
 
