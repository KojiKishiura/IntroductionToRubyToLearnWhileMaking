# -*- coding: utf-8 -*-
require 'rubygems'    # RubyGemsでインストールした時には記述
require 'dbi'             # DBIを使う

# dbhを作成し、データベース'fruits01.db'に接続する
# もしすでに存在するときは、そのデータベースファイルを開く
dbh = DBI.connect('DBI:SQLite3:fruits01.db')

# テーブルに登録されたデータを削除する
# delete文の実行
# sthにexecuteメソッドが返すステートメントハンドルを保持
sth = dbh.execute("delete from products")
puts "all records are deleted."

# ステートメントハンドルを開放する
sth.finish

# データベースとの接続を終了する
dbh.disconnect

