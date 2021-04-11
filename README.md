# qiita_tag_items

## できること
Qiitaの投稿記事にタグ情報がついている。
そのタグ情報の記事一覧をjsonファイルとして取得する。

v4以降ではmarkdownファイルも同時に作成する。

## 使用環境
### 動作確認済み
PC : MacBookPro(2020)  
OS : macOS 11.2.3  

v4以降、python使用

## 使い方
1. get_tags_*.shを編集

収集したいタグ名に変更  
例：リファクタリングをアンチパターンに変更

```get_tags_*.sh
# TAG_ID='リファクタリング'
TAG_ID='アンチパターン'
```

2. get_tags_*.shをコール
3. ranking_*.jsonを確認

## 使い方 v5以降
1. シェルからget_tags_v5.shをコール

例：タグ名は"Design"を指定する
```
$ ./get_tags_v5.sh Design
```
2. ranking_*.json / .mdを確認

## 出典
Qiita APIを使って特定タグの全記事リストを作る
https://qiita.com/YossyIto/items/5e87961bddae10e864b9

---
