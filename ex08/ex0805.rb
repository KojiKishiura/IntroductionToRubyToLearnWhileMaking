# -*- coding: utf-8 -*-
require 'date'

# 表示したい蔵書データを作成する
publish_date = Date.new( 2005, 1, 25)
mon_name = Date::MONTHNAMES[publish_date.mon]
abbr_mon_name = Date::ABBR_MONTHNAMES[publish_date.mon]

# 蔵書データを表示する
puts "出版年：" + publish_date.year.to_s
puts "出版月(long)：" + mon_name
puts "出版月(short)：" + abbr_mon_name
