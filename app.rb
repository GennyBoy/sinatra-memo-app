require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :show_exceptions, :after_handler

get '/' do
  @memos = JSON.load(File.read("db/memos/memos.json"))
  erb :'index'
end

get '/new' do
  erb :'new'
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  memo = {:title => title, :content => content }
  # 同じタイトルがあったら？
  # まずここでjsonファイルを読み込み、同じタイトルないか探してあったらエラー出す処理をかく?
  # 配列にする.一行ずつ読み込んで
  memos = JSON.load(File.read("db/memos/memos.json"))
  memos.push memo

  ### なぜか追加したやつだけstringになってるからそこの修正から
  # ファイルの書き込み処理
  File.open("db/memos/memos.json", "w") do |f|
    f.puts JSON.pretty_generate(memos)
  end

  redirect to('/')
end



