#!/bin/bash

cd "$(dirname "$0")" || exit 1

URL="http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"
FILE="apnic.txt"

if [ ! -f "$FILE" ]; then
	echo wget "$URL" -O "$FILE" || exit 1
fi

grep ipv4 "$FILE" | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' \
	> tmp.txt

date +%s >> tmp.txt

cmp tmp.txt ../ipv4.txt && exit 1

cp tmp.txt ../ipv4.txt

TZ="Asia/Shanghai"

TS=$(date +%s)
DATE=$(date -d @"$TS" '+%Y-%m-%d %H:%M:%S')

(
	echo "$TS"
	echo "$DATE"
) > ../time-modified.txt

export DATE
envsubst < ./tpl.html > ../index.html
