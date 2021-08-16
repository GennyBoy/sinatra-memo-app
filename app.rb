require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/reloader'

include ERB::Util

get '/' do
  @memos = load_all_memos
  erb :'index'
end

get '/new' do
  erb :'new'
end

get '/memos/:id' do |id|
  memos = load_all_memos

  @memo = fetch_memo_by_id(memos, id)

  erb :'show'
end

get '/memos/:id/edit' do |id|
  memos = load_all_memos

  @memo = fetch_memo_by_id(memos, id)

  erb :'edit'
end

post '/memos' do
  id = File.read("db/memos/index.txt").to_i
  memo = {:id => id, :title => h(params[:title]), :content => h(params[:content]) }
  memos = load_all_memos
  memos.push memo

  write_memos_json(memos)

  # idに1を足して、次に作成されるメモが連番になるようにする
  File.open("db/memos/index.txt", "w") { |f| f.puts id + 1 }

  redirect to('/')
end

patch '/memos/:id' do |id|
  memos = load_all_memos
  memo_to_edit = fetch_memo_by_id(memos, id)

  memo_to_edit["title"] = h(params[:title])
  memo_to_edit["content"] = h(params[:content])

  write_memos_json(memos)

  redirect to('/')
end

delete '/memos/:id' do |id|
  memos = load_all_memos

  memos.each_with_index do |memo, index|
    memos.delete_at index if memo["id"] == id.to_i
  end

  write_memos_json(memos)

  redirect to('/')
end

private

def load_all_memos
  JSON.load(File.read("db/memos/memos.json"))
end

def write_memos_json(memos)
  File.open("db/memos/memos.json", "w") { |f| f.puts JSON.pretty_generate(memos) }
end

def fetch_memo_by_id(memos, id)
  memos.each do |memo|
    if memo["id"] == id.to_i
      return memo
    end
  end
end

helpers do
  def h(text)
    escape_html(text)
  end
end


