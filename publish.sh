# 因为要在vscode中，使用。所以，第一行的解释器定义，先放弃掉。
# 参考：https://github.com/formulahendry/vscode-code-runner/issues/987#issuecomment-1464940228
##!/bin/bash
# apt-get install zip unzip
# apt-get install jq
# set -x
set -eu
set -o pipefail

name=my-ahks
version=v1.0
currentTime=$(date +"%m-%d_%H_%M")

zipName=$name-$version-${currentTime}.zip

zip -r ${zipName} **/*.png **/*.py **/*.ahk *.py *.ahk *.js **/*.js
# zip -r ${zipName} **/xunfei*.png xunfei*.ahk kou_tu.py

publishLogName=publish-log.md
# store 1-9.哪个可用用哪个
curl -F file=@${zipName} https://store9.gofile.io/uploadFile >rsp${currentTime}

log="[$(cat rsp${currentTime} | jq -r '.data.fileName')]($(cat rsp${currentTime} | jq -r '.data.downloadPage'))"

echo ${log}

if [ ! -f $publishLogName ]; then
    touch $publishLogName
    echo "## 发布记录" >>$publishLogName
    echo "" >>$publishLogName
fi
sed -i "2a${log}" ${publishLogName}

rm -rf ${zipName} rsp${currentTime}
