#!/bin/bash
LOGFILE="/usr/local/www/irs/log/restart.log"
Urls=( "http://irs.gis-lab.info/?layers=spot&" "http://irs.gis-lab.info/?layers=landsat&" "http://irs.gis-lab.info/?layers=irs&" "http://irs.gis-lab.info/?layers=osm&" )
Flag="1"
FlagOk="1"
FlagFail="0"
HttpOk="\"200\""
FailUrl=
HttpCode=
for url in "${Urls[@]}"
do
Result=`curl -s -o /dev/null -I -w \"%{http_code}\" $url`;
if [ "$Result" == "$HttpOk" ];
then
  Flag=$FlagOk
else
  Flag=$FlagFail
  HttpCode=$Result
  FailUrl=$url
  break
fi
done;
if [ "$Flag" == "$FlagFail" ]
then
  echo "[FAIL] `date +\"%D %T\"` Url: $FailUrl HttpCode: $HttpCode" >> $LOGFILE
  /usr/local/etc/rc.d/lighttpd restart
#else
#  echo "[SUCCESS] `date +\"%D %T\"` Everybody work!" >> $LOGFILE
fi
