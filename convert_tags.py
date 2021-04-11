# jsonファイルに含まれる情報をもとにmarkdownファイルに変換する
#
#　likes_count [title](url)  

# reference site
# https://qiita.com/niwasawa/items/9b9b76d4f7ddb5426159 
# https://qiita.com/kikuchiTakuya/items/53990fca06fb9ba1d8a7
# https://www.tech-teacher.jp/blog/python-commandline/


import sys
import argparse  # for argparce
import json

# コマンドライン引数を取得
parser = argparse.ArgumentParser( )
parser.add_argument('arg1')
args = parser.parse_args( )

filename_in = args.arg1
filename_out = filename_in + ".md"  # 拡張子を足すだけ

# ファイルオープン
print('********** JSONファイルを書き出す **********')
json_open = open(filename_in, 'r')
json_load = json.load(json_open)

print( "item_count=" + str( len(json_load) ) )
size = len(json_load)

# 出力ファイル
fw = open(filename_out,'w')
    
for x in range(0, size):
  title = json_load[x]['title']     # markdownで<>`があると正しく表示されないため、{}に置き換え
  title = title.replace('<', '{')
  title = title.replace('>', '}')
  title = title.replace("'", "-")
  title = title.replace("`", "-")
  
  c = str( json_load[x]['likes_count'] ) 
  c += ' [' + title + ']'
  c += '(' + json_load[x]['url'] + ')  '
  fw.write( c +'\n' )

# ファイルクローズ
json_open.close()
fw.close()
# eof