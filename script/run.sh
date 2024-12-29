#!/bin/bash -x

cd "$(dirname "$0")" || exit 1

URL="http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"
FILE="apnic.txt"

wget -q "$URL" -O "$FILE"

grep ipv4 "$FILE" | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' \
	> tmp.txt

cmp tmp.txt ../ipv4.txt && exit 0

cp tmp.txt ../ipv4.txt

TS=$(date +%s)
DATE=$(TZ="Asia/Shanghai" date -d @"$TS" '+%Y-%m-%d %H:%M:%S')

(
	echo "$TS"
	echo "$DATE"
) > ../time-modified.txt

export DATE
envsubst < ./tpl.html > ../index.html
