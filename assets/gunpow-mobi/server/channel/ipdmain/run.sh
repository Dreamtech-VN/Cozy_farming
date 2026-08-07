LIB_PATH=.
for i in ../../lib/*.jar; do
LIB_PATH=${LIB_PATH}:$i
done

for i in ../../serverLib/*.jar; do
LIB_PATH=${LIB_PATH}:$i
done


$JAVA_HOME/bin/java -server -Xmx5512M -Xms4096M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+PrintGC -Djava.awt.headless=true -classpath .:$CLASSPATH:$LIB_PATH:ipdserver.jar com.wyd.server.ipd.Main  >> stdout.log 2>&1 &

echo $! > dddipd.pid