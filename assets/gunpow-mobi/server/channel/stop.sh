#!/bin/bash
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                 GUNPOW STOPING CHANNEL                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::                        ipdmain Stop                          ::"
cd /home/ddd2/channel/ipdmain
./kill.sh
sleep 2
echo "::                     channelserver Stop                       ::"
cd /home/ddd2/channel/channelserver
./kill.sh
sleep 2
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                 GUNPOW STOPING CHANNEL                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"