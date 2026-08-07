#!/bin/bash
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                GUNPOW STARTING CHANNEL                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::                        ipdmain Start                         ::"
cd /home/ddd2/channel/ipdmain
./run.sh
sleep 2
echo "::                     channelserver Start                      ::"
cd /home/ddd2/channel/channelserver
./run.sh
sleep 2
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                GUNPOW STARTING CHANNEL                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"