#!/bin/bash
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-8071.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-8072.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-8073.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-8074.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-9071.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-9072.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-9073.pid`
kill -9 `cat /home/ddd2/redis/ipdredis/pid/redis-9074.pid`
ps aux | grep redis
