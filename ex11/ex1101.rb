# -*- coding: utf-8 -*-
# 新しいハッシュを作る
friends = {
  :shin => "Shin Kuboaki",
  :shinichirou => "Shinichirou Ooba",
  :shingo => "Shingo Katori"
}

# ハッシュの要素を１つずつ処理する
# 繰り返しの都度、キーと値をブロック内のローカル変数key, valueに渡す
friends.each {|key, value|
  # ローカル変数の値を表示する
  puts "#{key}, #{value}"
}