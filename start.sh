#!/bin/sh
cd /usr/local/bin/PaperMCserver/
. ./var.sh
#変数取り込み
if [ 1 -eq `screen -ls | grep "${scr}" | wc -l` ] ; then
  logger -s -p user.err -t [server] Already PaperMC server started.
  exit 1 #多重起動防止
else
  screen -AmdS ${scr} java -server -Xms${mem} -Xmx${mem} -jar paper-${ver}.jar nogui #通常起動
fi
logger -s -p user.info -t [server] PaperMC server started. You can use 'screen -r ${scr}' to access console.