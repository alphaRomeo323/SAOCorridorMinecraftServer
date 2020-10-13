#!/bin/sh
cd /usr/local/bin/PaperMCserver/
. ./var.sh
#変数取り込み
if [ 0 -eq `screen -ls | grep "${scr}" | wc -l` ] ; then
    logger -s -p user.info -t [server] Already PaperMC server stopped.
    exit 1 #↑多重停止防止
elif [ "${2}" = "f" ]; then
    screen -S ${scr} -X stuff $'stop\r' #即時終了
else
    screen -S ${scr} -X stuff $"say サーバーを停止します。(${int}秒前)\r"
    sleep ${int}
    screen -S ${scr} -X stuff $'stop\r' #↑終了
fi
count=0
while [ 1 -eq `screen -ls | grep "${scr}" | wc -l` ] ; do
  sleep ${mon}
  count=$(( ${count} + ${mon} ))
  if [ $count -gt $timeout ]; then
    # タイムアウト
    logger -s -p user.err -t [server] PaperMC server stop timeout detected.
    pkill -9 java
    logger -s -p user.err -t [server] PaperMC server force stopped.
    exit 2
  fi #終了監視
  done
logger -s -p user.info -t [server] PaperMC server was stopped safely.