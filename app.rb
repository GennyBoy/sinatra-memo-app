# frozen_string_literal: true

require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/reloader'

include ERB::Util

get '/' do
  @memos = parse_memos_json
  erb :index
end

get '/new' do
  erb :new
end

get '/memos/:id' do |id|
  memos = parse_memos_json

  @memo = fetch_memo_by_id(memos, id)

  erb :show
end

get '/memos/:id/edit' do |id|
  memos = parse_memos_json

  @memo = fetch_memo_by_id(memos, id)

  erb :edit
end

post '/memos' do
  id = File.read('db/memos/index.txt').to_i
  memo = { id: id, title: h(params[:title]), content: h(params[:content]) }
  memos = parse_memos_json
  memos.push memo

  write_memos_json(memos)

  # add 1 to make the id consecutive
  File.open('db/memos/index.txt', 'w') { |f| f.puts id + 1 }

  redirect to('/')
end

patch '/memos/:id' do |id|
  memos = parse_memos_json
  memo_to_edit = fetch_memo_by_id(memos, id)

  memo_to_edit[:title] = h(params[:title])
  memo_to_edit[:content] = h(params[:content])

  write_memos_json(memos)

  redirect to('/')
end

delete '/memos/:id' do |id|
  memos = parse_memos_json

  memos.delete_if { |memo| memo[:id] == id.to_i }

  write_memos_json(memos)

  redirect to('/')
end

private

def parse_memos_json
  JSON.parse(File.read('db/memos/memos.json'), symbolize_names: true)
end

def write_memos_json(memos)
  File.open('db/memos/memos.json', 'w') { |f| f.puts JSON.pretty_generate(memos) }
end

def fetch_memo_by_id(memos, id)
  memos.each do |memo|
    return memo if memo[:id] == id.to_i
  end
end
