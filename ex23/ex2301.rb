# -*- coding: utf-8 -*-
require 'rubygems'    # RubyGemsでインストールした時には記述
require 'dbi'             # DBIを使う
require 'date'

# 蔵書１冊分の蔵書データのクラスを作る
class BookInfo
  # BookInfoクラスのインスタンスを初期化する
  def initialize(title, author, yomi, publisher, page, price, purchase_price, isbn_10, isbn_13, size, publish_date, purchase_date)
    @title = title
    @author = author
    @yomi = yomi
    @publisher = publisher
    @page = page
    @price = price
    @purchase_price = purchase_price
    @isbn_10 = isbn_10
    @isbn_13 = isbn_13
    @size = size
    @publish_date = publish_date
    @purchase_date = purchase_date
  end

  # 最初に検討する属性に対するアクセサを提供する
  attr_accessor :title, :author, :yomi, :publisher, :page, :price, :purchase_price, :isbn_10, :isbn_13, :size, :publish_date, :purchase_date

  # BookInfoクラスのインスタンスをCSV形式へ変換する
  def to_csv(key)
    "#{key},#{@title},#{@author},#{@yomi},#{@publisher},#{@page},#{@price},#{@purchase_price},#{@isbn_10},#{@isbn_13},#{@size},#{@publish_date},#{@purchase_date}\n"
  end

  # BookInfoクラスのインスタンスの文字列表現を返す
  def to_s
    "#{key}, #{@title}, #{@author}, #{@yomi}, #{@publisher}, #{@page}, #{@price}, #{@purchase_price}, #{@isbn_10}, #{@isbn_13}, #{@size}, #{@publish_date}, #{@purchase_date}"
  end

  # 蔵書データを書式を付けて出力する操作を追加する
  # 項目の区切り文字を引数に指定することが出来る
  # 引数を省略した場合は開業を区切り文字にする
  def toFormattedString(sep="\n")
 "書籍名：#{@title}#{sep}著者名：#{@author}#{sep}よみがな：#{@yomi}#{sep}出版社：#{@publisher}#{sep}ページ数：#{@page}ページ#{sep}販売価格：#{@price}#{sep}購入費用：#{@purchase_price}#{sep}ISBN_10：#{@isbn_10}#{sep}ISBN_13：#{@isbn_13}#{sep}寸法：#{@size}#{sep}発刊日：#{@publish_date}#{sep}購入日：#{@purchase_date}#{sep}"
  end
end

# BookInfoManagerクラスを定義する
class BookInfoManager
  def initialize(sqlite_name)
    @db_name = sqlite_name
    @dbh = DBI.connect("DBI:SQLite3:#{@db_name}")
  end

  # 蔵書データベースを初期化する
  def initBookInfos
    puts "\n0.蔵書データベースの初期化"
    print "初期化しますか？（Y/yなら削除を実行します）："
    # 読み込んだ値を大文字に揃える
    yesno = gets.chomp.upcase
    if /^Y$/ =~ yesno
      # Yが１文字の時だけ、初期化する
      # もしすでにこのデータベースにテーブル'bookinfos'があれば削除する
      @dbh.do("drop table if exists bookinfos")
      # 新しく'bookinfos'テーブルを作成する
      @dbh.do("create table bookinfos(
        id                    varchar(50)         not null,
        title                 varchar(100)       not null,
        author             varchar(100)       not null,
        yomi                varchar(100)       not null,
        publisher          varchar(100)       not null,
        page                int                      not null,
        price               int                      not null,
        purchase_price  int                      not null,
        isbn_10            varchar(10)         not null,
        isbn_13            varchar(13)         not null,
        size                 varchar(20)          not null,
        publish_date     datetime              not null,
        purchase_date  datetime              not null,
        primary           key(id))")
      puts "\nデータベースを初期化しました。"
    end
  end

  # 蔵書データを登録する
  def addBookInfo
    puts "\n1.蔵書データの登録"
    print "蔵書データを登録します。"

    # 蔵書データ1件分のインスタンスを作成する
    book_info = BookInfo.new("", "", "", "", 0, 0, 0, "", "", "", Date.new, Date.new)
    # 登録するデータを項目ごとに入力する
    print "\n"
    print "キー："
    key = gets.chomp
    print '書籍名：'
    book_info.title = gets.chomp
    print '著者名：'
    book_info.author = gets.chomp
    print 'よみがな：'
    book_info.yomi = gets.chomp
    print '出版社：'
    book_info.publisher = gets.chomp
    print 'ページ数：'
    book_info.page = gets.chomp.to_i
    print '販売価格：'
    book_info.price = gets.chomp.to_i
    print '購入費用：'
    book_info.purchase_price = gets.chomp.to_i
    print 'ISBN_10：'
    book_info.isbn_10 = gets.chomp
    print 'ISBN_13：'
    book_info.isbn_13 = gets.chomp
    print '寸法：'
    book_info.size = gets.chomp
    print "発刊年："
    publish_year = gets.chomp.to_i
    print "発刊月："
    publish_month = gets.chomp.to_i
    print "発刊日："
    publish_day = gets.chomp.to_i
    book_info.publish_date = Date.new( publish_year, publish_month, publish_day)
    print "購入年："
    purchase_year = gets.chomp.to_i
    print "購入月："
    purchase_month = gets.chomp.to_i
    print "購入日："
    purchase_day = gets.chomp.to_i
    book_info.purchase_date = Date.new( purchase_year, purchase_month, purchase_day)
    # 作成した蔵書データの1件分をデータベースに登録する
    @dbh.do("insert into bookinfos values (
                \'#{key}\',
                \'#{book_info.title}\',
                \'#{book_info.author}\',
                \'#{book_info.yomi}\',
                \'#{book_info.publisher}\',
                #{book_info.page},
                #{book_info.price},
                #{book_info.purchase_price},
                \'#{book_info.isbn_10}\',
                \'#{book_info.isbn_13}\',
                \'#{book_info.size}\',
                \'#{book_info.publish_date}\',
                \'#{book_info.purchase_date}\');")
    puts "\n登録しました"
  end

  # 蔵書データの一覧を表示する
  def listAllBookInfos
    # テーブル上の項目名を日本語に変えるハッシュテーブル
    item_name = {'id' => "キー", 'title' => "書籍名", 'author' => "著者名", 'yomi' => "よみがな", 'publisher' => "出版社", 'page' => "ページ数", 'price' => "販売価格", 'purchase_price' => "購入費用", 'isbn_10' => "ISBN_10", 'isbn_13' => "ISBN_13", 'size' => "寸法", 'publish_date' => "発刊日", 'purchase_date' => "購入日",}
    puts "\n2.蔵書データの表示"
    print "蔵書データを表示します"
    puts "\n---------------"
    # テーブルからデータを読み込んで表示する
    sth = @dbh.execute("select *from bookinfos")

    # selec文の結果を１件ずつrowに取り出し、繰り返し処理する
    counts = 0
    sth.each do |row|
      # rowは１件分のデータを保持しているので
      # each_with_nameメソッドで値と項目名を取り出して表示する
      row.each_with_name do |val, name|
        # 項目名を日本語に変換して表示する
        puts "#{item_name[name]}： #{val.to_s}"
      end
      puts "\n---------------"
      counts = counts + 1
    end
    # 実行結果を開放する
    sth.finish
    puts "\n#{counts}件表示しました。"
  end

  # 処理の選択と選択後の処理を繰り返す
  def run
    while true
      # 機能選択画面を表示する
      print "
0. 蔵書データベースの初期化
1. 蔵書データの登録
2. 蔵書データの表示
9. 終了
番号を選んでください（0,1,2,9）："
      # 文字の入力を待つ
      num = gets.chomp
      case
      when '0' == num
        # 蔵書データベースの初期化
        initBookInfos
      when '1' == num
        # 蔵書データの登録
        addBookInfo
      when '2' == num
        # 蔵書データの表示
        listAllBookInfos
      when '9' == num
        # データベースとの接続を終了する
        @dbh.disconnect
        # アプリケーションの終了
        puts "\n終了しました。"
        break;
      else
        # 処理選択待ち画面に戻る
      end
    end
  end
end

# アプリケーションのインスタンスを作る
book_info_manager = BookInfoManager.new("ex23/bookinfo_sqlite.db")

# BookInfoManagerの処理の選択と選択後の処理を繰り返す
book_info_manager.run 

