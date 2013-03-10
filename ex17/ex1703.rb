# -*- coding: utf-8 -*-

# 行番号用の変数
line_no = 0

# "sample1.txt"を読み込みモードでオープンする
file = open("sample1.txt", "r:UTF-8")

# ファイルの終わりまで、1行ずつlineに読み込む
file.each { |line|
  # lineを表示する
  print line
}

# ファイルを閉じる
file.close