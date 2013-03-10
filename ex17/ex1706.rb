# -*- coding: utf-8 -*-

# "sample1.txt"を読み込みモードでオープンする
open("sample1.txt", "r:UTF-8") { |file|
  # ファイルの終わりまで、1行ずつlineに読み込む
  file.each { |line|
    # lineを表示する
    print line
  }
}
