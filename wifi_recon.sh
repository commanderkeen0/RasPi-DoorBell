#!/bin/bash

PCNT=1
HOST="gmastap.com"

while true

 do

  CONTST=$(ping $HOST -c $PCNT | grep "packets transmitted"  | awk '{print $4 }')
 # echo $CONTST

    if [[ $CONTST -eq 0 ]]
     then
          wpa_cli -i wlan0 reconnect
        fi


 sleep 120

 done
