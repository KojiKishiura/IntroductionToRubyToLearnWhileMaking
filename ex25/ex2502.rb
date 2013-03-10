# -*- coding: utf-8 -*-
require 'webrick'     # WEBrickを使うときは記述する

# サーバの設定を書いたハッシュを用意する
# ポートは通常使う８０版ではなく、使ってなさそうなポート番号にしておく
# 8099は開いていそうなポート番号の例
# DocumentRootあ文書のある場所
# ここでは現在のディレクトリを表す「.」を指定している
config = {
  :Port => 8099,
  :DocumentRoot => '.',
}

# WEBrickのHTTP Serverクラスのサーバーインスタンスを作成する
server = WEBrick::HTTPServer.new(config)

# Ctrl-C割り込みがあった場合にサーバを停止する処理を登録しておく
trap(:INT) do
  server.shutdown
end

# 上記記述の処理をこなすサーバを開始する
server.start