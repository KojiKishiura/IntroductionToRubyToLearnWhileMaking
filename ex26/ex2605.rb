# -*- coding: utf-8 -*-
require 'webrick'

config = {
  :Port => 8099,
  :DocumentRoot => '.',
}

# 拡張子erbのファイルをERBを呼び出して処理するERBHandelerと関連付ける
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)

# WEBrickのHTTP Serverクラスのサーバーインスタンスを作成する
server = WEBrick::HTTPServer.new(config)

# erbのMIMEタイプを設定
server.config[:MimeTypes]["erb"] = "text/html"

# Ctrl-C割り込みがあった場合にサーバを停止する処理を登録しておく
trap(:INT) do
  server.shutdown
end

# 上記記述の処理をこなすサーバを開始する
server.start