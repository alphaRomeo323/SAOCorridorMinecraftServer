#!/bin/bash
cd /usr/local/bin/PaperMCserver/
. ./var.sh
#変数取り込み
if [ 0 -eq `screen -ls | grep "${scr}" | wc -l` ] ; then
  logger -s -p user.info -t [server] PaperMC server stopped.
else
  screen -S ${scr} -X stuff $"${*}"
fi
