#!/bin/bash
#変数セット
ver=122 #papermc-xxx.jarのバージョン番号
mem="2048M" #メモリ割り当て(byte)
scr="papermc" #Screenのホスト名
int=10 #終了インターバル(sec)
mon=5 #監視インターバル(sec)
timeout=120 #最大監視時間(sec)
if [ "${1}" = "help" ] || [ -z "${1}" ]; then
  echo -e "PaperMC Server Control.sh Help\n\nstart...サーバーを起動\nstop...サーバーを${int}秒後に終了\nstop f...サーバーを即時に終了\nbackup...サーバーの自動バックアップを実行"
  #ヘルプを表示
elif [ "${1}" = "stop" ]; then #ストップ
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
    fi #↑終了監視
  done
elif [ "${1}" = "start" ]; then #スタート
  if [ 1 -eq `screen -ls | grep "${scr}" | wc -l` ] ; then
    logger -s -p user.info -t [server] Already PaperMC server stopped.
    exit 3 #↑多重起動防止
  else
    screen -AmdS ${scr} java -server -Xms${mem} -Xmx${mem} -jar paper-${ver}.jar nogui #通常起動
  fi
elif [ "${1}" = "backup" ]; then #バックアップ
  if [ 0 -eq `screen -ls | grep "${scr}" | wc -l` ] ; then
    logger -s -p user.info -t [server] Now PaperMC server stopped.
    exit 4 #↑起動確認
  else
    screen -S ${scr} -X stuff $'backup\r' #バックアップ実行
  fi
else
  echo "Server Control Failed : 不適切な引数が検出されました。(${1})"
fi