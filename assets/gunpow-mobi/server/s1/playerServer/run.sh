B_PATH=.
for i in ../../lib/*.jar; do
LIB_PATH=${LIB_PATH}:$i
done

for i in ../../serverLib/*.jar; do
LIB_PATH=${LIB_PATH}:$i
done

$JAVA_HOME/bin/java -server -Xmx5512M -Xms4096M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+PrintGC -Djava.awt.headless=true -javaagent:../../serverLib/reloadserver.jar=playerserver.jar#../../serverLib/cache.jar#../../serverLib/empirenetprotocol.jar#../../serverLib/netprotocol.jar -classpath .:$CLASSPATH:$LIB_PATH:playerserver.jar com.wyd.empire.player.PlayerServer >> stdout.log 2>&1 &

echo $! > dddplayerserver.pid
