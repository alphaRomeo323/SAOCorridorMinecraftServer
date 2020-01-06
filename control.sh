#!/bin/bash
#変数セット
ver=238 #papermc-xxx.jarのバージョン番号
mem="1024M" #メモリ割り当て(byte)
int=10 #終了インターバル(sec)
mon=5 #監視インターバル(sec)
timeout=120 #最大監視時間(sec)
if [ "${1}" = "help" ] || [ -z "${1}"]; then
  echo -e "PaperMC Server Control.sh Help\n\nstart...サーバーをバックグラウンドで起動\nstart t...サーバーをテストモード(ログ表示状態)で起動\nstop...サーバーを${int}秒後に終了\nstop f...サーバーを即時に終了"
  #ヘルプを表示
elif [ "${1}" = "stop" ]; then #ストップ
  if [ 0 -eq `screen -ls | grep "papermc" | wc -l` ] ; then
    logger -s -p user.info -t [server] Already PaperMC server stopped.
    exit 1 #↑多重停止防止
  elif [ "${2}" = "f" ]; then
    screen -S papermc -X stuff $'stop\r' #即時終了
  else
    screen -S papermc -X stuff $"say サーバーを停止します。(${int}秒前)\r"
    sleep ${int}
    screen -S papermc -X stuff $'stop\r' #↑終了
  fi
  count=0
  while [ 1 -eq `screen -ls | grep "papermc" | wc -l` ] ; do
    sleep ${mon}
    count=$(( ${count} + ${mon} ))
    if [ $COUNT -gt $timeout ]; then
        # タイムアウト
        logger -s -p user.err -t [server] PaperMC server stop timeout detected.
        pkill -9 java
        logger -s -p user.err -t [server] PaperMC server force stopped.
        exit 2
    fi #↑終了監視
  done
elif [ "${1}" = "start" ]; then #スタート
  if [ 1 -eq `screen -ls | grep "papermc" | wc -l` ] ; then
    logger -s -p user.info -t [server] Already started PaperMC server.
    exit 3
  elif [ "${2}" = "t" ]
    screen -AmdS papermc java -server -Xms${mem} -Xmx${mem} -jar paper-${ver}.jar
  else
    screen -AmdS papermc java -server -Xms${mem} -Xmx${mem} -jar paper-${ver}.jar nogui
  fi
else
  echo "Server Control Failed : 不適切な引数が検出されました。(${1})"
fi