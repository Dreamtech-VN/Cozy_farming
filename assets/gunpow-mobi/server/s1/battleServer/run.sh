B_PATH=.
for i in ../../lib/*.jar; do
LIB_PATH=${LIB_PATH}:$i
done

for i in ../../serverLib/*.jar; do
LIB_PATH=${LIB_PATH}:$i
done

$JAVA_HOME/bin/java -server -Xmx5512M -Xms4096M -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+PrintGC -Djava.awt.headless=true -javaagent:../../serverLib/reloadserver.jar=battleserver.jar#../../serverLib/cache.jar#../../serverLib/empirenetprotocol.jar#../../serverLib/netprotocol.jar -classpath .:$CLASSPATH:$LIB_PATH:battleserver.jar com.wyd.empire.battle.BattleServer >> stdout.log 2>&1 &

echo $! > dddbattleserver.pid
