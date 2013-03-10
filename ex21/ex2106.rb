# -*- coding: utf-8 -*-
require 'rubygems'    # RubyGemsでインストールした時には記述
require 'dbi'             # DBIを使う

# dbhを作成し、データベース'students01.db'に接続する
# 引数は、データソース名（DSN=data source name)を指定する
# DSNの第１要素はデータソースの種別：DBIでは'DBI'
# DSNの第２要素はドライバ種類：'SQLite3'
# DSNの第３要素はデータベースソースファイル名：students01.db
dbh = DBI.connect('DBI:SQLite3:students01.db')

# select文でデータを検索し、読み込んだデータを表示する
dbh.select_all('select * from students') do |row|
  # SQLを実行し１行ずつrowで受け取ってブロックを処理する
  print "row=#{row}              \n"
  print "    name = #{row[0]}\n"
  print "    age    = #{row[1]}\n"
  print "\n"
end

# データベースとの接続を終了する
dbh.disconnect

