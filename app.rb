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

get '/memos/:id' do |id|
  memos = load_all_memos

  memos.each do |memo|
    if memo["id"] == id.to_i
      @memo = memo
      break
    end
  end

  erb :'show'
end

get '/memos/:id/edit' do |id|
  memos = load_all_memos

  memos.each do |memo|
    if memo["id"] == id.to_i
      @memo = memo
      break
    end
  end

  erb :'edit'
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

patch '/memos/:id' do |id|
  memos = load_all_memos
  memo_to_edit = search_memo_by_id(memos, id)

  memo_to_edit["title"] = params[:title]
  memo_to_edit["content"] = params[:content]

  File.open("db/memos/memos.json", "w") { |f| f.puts JSON.pretty_generate(memos) }

  redirect to('/')
end

delete '/delete' do
  # TODO
end

private

def load_all_memos
  JSON.load(File.read("db/memos/memos.json"))
end

def search_memo_by_id(memos, id)
  memos.each do |memo|
    if memo["id"] == id.to_i
      return memo
    end
  end
end



