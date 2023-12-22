#!/bin/bash
# apt-get install zip unzip
# apt-get install jq

set -e
name=my-ahks
version=v1.0
currentTime=$(date +"%m-%d_%H_%M")

publicLogFile=publish-log.md

if [ ! -f $publicLogFile ];then
    touch $publicLogFile
    echo "## 发布记录" >> $publicLogFile
    echo "" >> $publicLogFile
fi

zipName=$name-$version-${currentTime}.zip
zip -r ${zipName} **/*.png **/*.py **/*.ahk

curl -F file=@${zipName} https://store1.gofile.io/uploadFile > rsp${currentTime}

log="[$(cat rsp${currentTime} | jq -r '.data.fileName')]($(cat rsp${currentTime} | jq -r '.data.downloadPage'))"

echo ${log}

sed -i "2a${log}" ${publicLogFile}

rm -rf ${zipName} rsp${currentTime}

