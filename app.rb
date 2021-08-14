require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :show_exceptions, :after_handler

get '/' do
  @memos = load_all_memos
  erb :'index'
end

get '/new' do
  erb :'new'
end

get '/show' do
  # ここでタイトルをうけとらないとだめ
  title = "これは工藤のメモのテストです"
  memos = load_all_memos
  memos.each do |memo|
    if memo["title"] == title
      @memo = memo
      break
    end
  end
  erb :'show'
end

post '/memos' do
  id = File.read("db/memos/index.txt").to_i
  memo = {:id => id, :title => params[:title], :content => params[:content] }
  memos = load_all_memos
  memos.push memo

  File.open("db/memos/memos.json", "w") { |f| f.puts JSON.pretty_generate(memos) }

  # idに1を足して、次に作成されるメモが連番になるようにする
  File.open("db/memos/index.txt", "w") { |f| f.puts id + 1 }

  redirect to('/')
end

delete '/delete' do
  # TODO
end

patch '/edit' do
  # TODO
end

private

def load_all_memos
  JSON.load(File.read("db/memos/memos.json"))
end



