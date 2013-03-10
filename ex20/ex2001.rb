# -*- coding: utf-8 -*-
require 'date'
require 'pstore'

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
  def initialize(pstore_name)
    # PStoreデータベースファイルを指定して初期化
    @db = PStore.new(pstore_name)
  end
  # 蔵書データを登録する
  def addBookInfo
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
    # 作成した蔵書データを１件分をPStoreデータベースに登録する
    @db.transaction do
      # 蔵書データをPStoreに保存する
      @db[key] = book_info
    end
  end

  # 蔵書データの一覧を表示する
  def listAllBookInfos
    puts "\n---------------"
    @db.transaction(true) do  # 読み込みモード
      # rootsがキーの配列を返し、eachでそれを１件ずつ処理
      @db.roots.each { |key|
        # 得られたキーを使ってPstoreから蔵書データ（BookInfo）を取得
        # それに書式をつけて出力する
        puts "キー：#{key}"
        print @db[key].toFormattedString
        puts "\n---------------"
      }
    end
  end

  # 蔵書データを削除する
  def delBookInfo
    # キーを指定してもらう
    print "\n"
    print "キーを指定してください："
    key = gets.chomp

    # 削除対象データを確認してから削除する
    @db.transaction do
      if @db.root?(key)
        print @db[key].toFormattedString
        print "\n削除しますか？(Y/yなら削除を実行します）："
        # 読み込んだ文字を大文字に揃える
        yesno = gets.chomp.upcase
        if /^Y$/ =~ yesno
          # Yが１文字の時だけ、PStoreデータベースから削除する
          @db.delete(key)
          puts "\nデータベースから削除しました"
        end
      end
    end
  end

  # 処理の選択と選択後の処理を繰り返す
  def run
    while true
      # 機能選択画面を表示する
      print "
1. 蔵書データの登録
2. 蔵書データの表示
3. 蔵書データの削除
9. 終了
番号を選んでください（1,2,3,9）："
      # 文字の入力を待つ
      num = gets.chomp
      case
      when '1' == num
        # 蔵書データの登録
        addBookInfo
      when '2' == num
        # 蔵書データの表示
        listAllBookInfos
      when '3' == num
        # 蔵書データを削除
        delBookInfo
      when '9' == num
        # アプリケーションの実行
        break;
      else
        # 処理選択待ち画面に戻る
      end
    end
  end
end

# アプリケーションのインスタンスを作る
book_info_manager = BookInfoManager.new("ex19/book_info.db")

# BookInfoManagerの処理の選択と選択後の処理を繰り返す
book_info_manager.run 

