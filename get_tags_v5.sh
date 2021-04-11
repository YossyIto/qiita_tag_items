#!/bin/zsh

VERSION=0.5.1
# --------------------------------------------------------
set -eu && :<<'USAGE'
Usage: $(basename "$0") [-h | --help] TAG_ID

Options:
  -h | --help   Display this help
  TAG_ID        Tag name to extract

Version: $VERSION
USAGE

usage() {
  while IFS= read -r line && [ ! "${line#*:}" = "<<'$1'" ]; do :; done
  while IFS= read -r line && [ ! "$line" = "$1" ]; do set "$@" "$line"; done
  shift && [ $# -eq 0 ] || printf '%s\n' "cat<<$line" "$@" "$line"
}

case ${1:-} in (-h | --help)
  eval "$(usage "USAGE" < "$0")"
  exit 0
esac
# --------------------------------------------------------

# 対象タグ名の取得
if [ -z "$1" ]; then
	echo "TAG_ID is blank"
	
	exit 1
else
	TAG_ID="${1}"
fi

# 日付を取得
DATE_NOW=`date +%Y-%m-%dT`
DATE_AGO_YEAR=`date -v -1y +%Y-%m-%dT`				#for Mac -dオプションが違う

# 出力ファイル名を設定
DATE_NOW=`date +%Y-%m-%dT`
TAGS_FILE="tags_${TAG_ID}_${DATE_NOW}.json"
RANKINGFILE="ranking_${TAG_ID}_${DATE_NOW}.json"
echo "TAGS_FILE=${TAGS_FILE}"
echo "RANKINGFILE=${RANKINGFILE}"

# qiitaから対象タグの記事数を取得する
curl "https://qiita.com/api/v2/tags/${TAG_ID}" | jq '.' > tags_detail.json
ITEM_COUNT=$(jq '. | .items_count'  tags_detail.json)
PAGE_COUNT=$(( $(( $ITEM_COUNT + 99)) /100 ))
echo "ITEM_COUNT=${ITEM_COUNT}, PAGE_COUNT=${PAGE_COUNT}"

if [ "${PAGE_COUNT}" -eq "0" ]; then
	echo "[${TAG_ID}] item is empty"
	exit 1
fi

# qiitaから対象タグの全記事を一覧取得する
cp /dev/null ${TAGS_FILE}  # ファイルを空にしておく
for (( i=1; i<=${PAGE_COUNT} ;i++ ))
do
  ss="curl 'https://qiita.com/api/v2/tags/${TAG_ID}/items?page=${i}&per_page=100' | jq '.[] | { likes_count: .likes_count, title: .title, url: .url}' >> ${TAGS_FILE}"
  eval $ss
done 

# sort 降順
jq 'sort_by(.likes_count) | reverse' --slurp ${TAGS_FILE}  > ${RANKINGFILE}

# markdown ファイルに変換
python convert_tags.py ${RANKINGFILE}
# end
