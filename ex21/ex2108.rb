# -*- coding: utf-8 -*-
require 'rubygems'    # RubyGemsでインストールした時には記述
require 'dbi'             # DBIを使う

# dbhを作成し、データベース'fruits01.db'に接続する
# もしすでに存在するときは、そのデータベースファイルを開く
dbh = DBI.connect('DBI:SQLite3:fruits01.db')


# テーブルにデータを追加する
dbh.do("insert into products values(
  1,
  'apple',
  'This is Kunimitsu call for UnderSnow',
  '/images/kokkou.jpg',
  '300',
  '2009-02-01 09:15:00'
  );")

dbh.do("insert into products values(
  2,
  'Mangifera',
  'This is SunEgg from Miyazaki',
  '/images/mango.jpg',
  '2000',
  '2009-03-20 00:00:00'
  );")

puts "2 records inserted"


# データベースとの接続を終了する
dbh.disconnect

