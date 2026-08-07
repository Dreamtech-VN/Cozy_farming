#!/bin/bash
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                  GUNPOW STOPING REDIS                      :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                        Redis Stop                          :::"
cd /home/ddd2/redis/gameredis
./kill.sh
sleep 2
cd /home/ddd2/redis/ipdredis
./kill.sh
sleep 2
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                  GUNPOW STOPING REDIS                      :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"