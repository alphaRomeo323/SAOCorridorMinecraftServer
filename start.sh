#!/bin/sh
cd /usr/local/bin/PaperMCserver/
. ./var.sh
#変数取り込み
screen -Dm -S ${scr} java -Xms${mem} -Xmx${mem} -jar paper-${ver}.jar
echo "PaperMC server started. You can use screen -r ${scr} to access console."
