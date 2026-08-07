#!/bin/bash
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                 GUNPOW STARTING SERVER                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::                     battleManage Start                       ::"
cd /home/ddd2/s1/battleManage
./run.sh
sleep 2
echo "::                     battleServer Start                       ::"
cd /home/ddd2/s1/battleServer
./run.sh
sleep 2
echo "::                     chatServer Start                         ::"
cd /home/ddd2/s1/chatServer
./run.sh
sleep 2
echo "::                      friendServer Start                      ::"
cd /home/ddd2/s1/friendServer
./run.sh
sleep 2
echo "::                      playerServer Start                      ::"
cd /home/ddd2/s1/playerServer
./run.sh
sleep 2
echo "::                       roomServer Start                       ::"
cd /home/ddd2/s1/roomServer
./run.sh
sleep 2
echo "::                    transactionServer Start                   ::"
cd /home/ddd2/s1/transactionServer
./run.sh
sleep 2
echo "::                      dispatchServer Start                    ::"
cd /home/ddd2/s1/dispatchServer
./run.sh
sleep 2
echo "::                       worldServer Start                      ::"
cd /home/ddd2/s1/worldServer
./run.sh
sleep 2
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                 GUNPOW STARTING SERVER                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"