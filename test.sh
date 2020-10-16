#!/bin/sh
cd /usr/local/bin/PaperMCserver/
. ./var.sh
#変数取り込み
if [ 1 -eq `screen -ls | grep "${scr}" | wc -l` ] ; then
  logger -s -p user.info -t [server] Already PaperMC server stopped.
  exit 1 #↑多重起動防止
else
  screen -AmdS ${scr} java -Xms${mem} -Xmx${mem} -jar paper-${ver}.jar nogui
fi