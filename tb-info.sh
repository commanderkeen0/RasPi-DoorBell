#!/bin/bash
#
# Philipp Griessler - IT Principel Consultant
# http://www.onemanarmy.biz
#
# Get debug information about the bot account and associated groups
#
# Verion 0.1

# include authentication parameter for Telegram
source /opt/doorbell/door.cfg


# send and create Message
#	curl -s  -X GET $URL/getMe
 curl -i --max-time $TIMEOUT -X GET https://api.telegram.org/bot$KEY/getMe
 echo "."
 echo "-----------------------------"
 curl -i --max-time $TIMEOUT -X GET https://api.telegram.org/bot$KEY/getUpdates
