# -*- coding: utf-8 -*-
require 'rubygems'    # RubyGemsでインストールした時には記述
require 'dbi'             # DBIを使う

# dbhを作成し、データベース'fruits01.db'に接続する
# もしすでに存在するときは、そのデータベースファイルを開く
dbh = DBI.connect('DBI:SQLite3:fruits01.db')


# テーブル空データを読み込んで表示する
# SELECT文の実行
sth = dbh.execute("select * from products")
# SELECT文の実行結果を１件ずつrowに取り出し、繰り返し処理する
sth.each do |row|
  # rowは１件分のデータを保持しているので
  # each_with_nameメソッドで値と項目名を取り出して表示する
  row.each_with_name do |val, name|
    puts "#{name}: #{val.to_s}"
  end
  puts "----------"
end
# 実行結果を開放する
sth.finish
# データベースとの接続を終了する
dbh.disconnect

