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
  memo = {:title => params[:title], :content => params[:content] }
  memos = load_all_memos
  memos.push memo

  File.open("db/memos/memos.json", "w") do |f|
    f.puts JSON.pretty_generate(memos)
  end

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



