#!/bin/bash
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-8091.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-8092.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-8093.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-8094.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-9091.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-9092.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-9093.pid`
kill -9 `cat /home/ddd2/redis/gameredis/pid/redis-9094.pid`
ps aux | grep redis
