#!/bin/sh
cd /usr/local/bin/PaperMCserver/
. ./var.sh
#変数取り込み
screen -S ${scr} -X stuff $"say サーバーを停止します。(${int}秒前)\r"
sleep ${int}
screen -S ${scr} -X stuff $'stop\r' #↑終了
while [ 1 -eq `screen -ls | grep "${scr}" | wc -l` ] ; do
  sleep ${mon}
  count=$(( ${count} + ${mon} ))
  if [ $count -gt $timeout ]; then
    # タイムアウト
    echo PaperMC server stop timeout detected.
    pkill -9 java
    echo PaperMC server force stopped.
    exit 2
  fi #終了監視
  done
echo PaperMC server was stopped safely.