#!/bin/bash
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                 GUNPOW STARTING REDIS                      :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                        Redis Start                         :::"
cd /home/ddd2/redis/gameredis
./run.sh
sleep 2
cd /home/ddd2/redis/ipdredis
./run.sh
sleep 2
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ":::                 GUNPOW STARTING REDIS                      :::"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"