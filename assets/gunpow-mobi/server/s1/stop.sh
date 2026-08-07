#!/bin/bash
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                  GUNPOW STOPING SERVER                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::                     battleManage Stop                       ::"
cd /home/ddd2/s1/battleManage
./kill.sh
sleep 2
echo "::                     battleServer Stop                       ::"
cd /home/ddd2/s1/battleServer
./kill.sh
sleep 2
echo "::                     chatServer Stop                         ::"
cd /home/ddd2/s1/chatServer
./kill.sh
sleep 2
echo "::                      friendServer Stop                      ::"
cd /home/ddd2/s1/friendServer
./kill.sh
sleep 2
echo "::                      playerServer Stop                      ::"
cd /home/ddd2/s1/playerServer
./kill.sh
sleep 2
echo "::                       roomServer Stop                       ::"
cd /home/ddd2/s1/roomServer
./kill.sh
sleep 2
echo "::                    transactionServer Stop                   ::"
cd /home/ddd2/s1/transactionServer
./kill.sh
sleep 2
echo "::                      dispatchServer Stop                    ::"
cd /home/ddd2/s1/dispatchServer
./kill.sh
sleep 2
echo "::                       worldServer Stop                      ::"
cd /home/ddd2/s1/worldServer
./kill.sh
sleep 2
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                  GUNPOW STOPING SERVER                     :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"