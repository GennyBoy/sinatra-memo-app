# frozen_string_literal: true

require 'erb'
require 'json'
require 'pg'
require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'

include ERB::Util

get '/' do
  @memos = fetch_memos

  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |id|
  memos = fetch_memos

  @memo = fetch_memo_by_id(memos, id)

  if @memo.nil?
    erb :notfound
  else
    erb :show
  end
end

get '/memos/:id/edit' do |id|
  memos = fetch_memos

  @memo = fetch_memo_by_id(memos, id)

  erb :edit
end

post '/memos' do
  memo = { id: SecureRandom.uuid, title: params[:title], content: params[:content] }
  memos = parse_memos_json
  memos.push memo

  write_memos_json(memos)

  redirect to('/')
end

patch '/memos/:id' do |id|
  memos = parse_memos_json
  memo_to_edit = fetch_memo_by_id(memos, id)

  memo_to_edit[:title] = params[:title]
  memo_to_edit[:content] = params[:content]

  write_memos_json(memos)

  redirect to('/')
end

delete '/memos/:id' do |id|
  memos = parse_memos_json

  memos.delete_if { |memo| memo[:id] == id }

  write_memos_json(memos)

  redirect to('/')
end

not_found do
  erb :notfound
end

private

def parse_memos_json
  JSON.parse(File.read('db/memos/memos.json'), symbolize_names: true)
end

def write_memos_json(memos)
  File.open('db/memos/memos.json', 'w') { |f| f.puts JSON.pretty_generate(memos) }
end

def fetch_memos
  conn = PG.connect( dbname: 'memoapp' )
  results = conn.exec(
    "SELECT * FROM memos"
  )
  (0..results.ntuples-1).map { |n| results[n] }
end

def fetch_memo_by_id(memos, id)
  memos.find { |memo| memo["id"] == id }
end
