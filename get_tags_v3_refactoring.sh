#!/bin/zsh

# 日付を取得
DATE_NOW=`date +%Y-%m-%dT`
DATE_AGO_YEAR=`date -v -1y +%Y-%m-%dT`				#for Mac -dオプションが違う

# 出力ファイル名を設定
TAG_ID='リファクタリング'
DATE_NOW=`date +%Y-%m-%dT`
TAGS_FILE="tags_${TAG_ID}_${DATE_NOW}.json"
RANKINGFILE="ranking_${TAG_ID}_${DATE_NOW}.json"
echo "TAGS_FILE=${TAGS_FILE}, RANKINGFILE=${RANKINGFILE}"

# qiitaから対象タグの記事数を取得する
curl "https://qiita.com/api/v2/tags/${TAG_ID}" | jq '.' > tags_detail.json
ITEM_COUNT=$(jq '. | .items_count'  tags_detail.json)
PAGE_COUNT=$(( $(( $ITEM_COUNT + 99)) /100 ))
echo "ITEM_COUNT=${ITEM_COUNT}, PAGE_COUNT=${PAGE_COUNT}"

# qiitaから対象タグの全記事を一覧取得する
cp /dev/null ${TAGS_FILE}  # ファイルを空にしておく
for (( i=1; i<=${PAGE_COUNT} ;i++ ))
do
#  echo ${i}
  ss="curl 'https://qiita.com/api/v2/tags/${TAG_ID}/items?page=${i}&per_page=100' | jq '.[] | { likes_count: .likes_count, title: .title, url: .url}' >> ${TAGS_FILE}"
  eval $ss
done 
# sort 降順
jq 'sort_by(.likes_count) | reverse' --slurp ${TAGS_FILE}  > ${RANKINGFILE}
# end