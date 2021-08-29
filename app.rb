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
  insert_memo(SecureRandom.uuid, params[:title], params[:content])

  redirect to('/')
end

patch '/memos/:id' do |id|
  update_memo(id, params[:title], params[:content])

  redirect to('/')
end

delete '/memos/:id' do |id|
  delete_memo(id)

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

def insert_memo(id, title, content)
  current_time = Time.now
  conn = PG.connect(dbname: 'memoapp')
  conn.exec(
    "INSERT INTO memos (
      id, title, content, created_at, updated_at
    )
    VALUES
    (
      '#{id}', '#{title}', '#{content}', '#{current_time}', '#{current_time}'
    )"
  )
end

def update_memo(id, title, content)
  current_time = Time.now
  conn = PG.connect(dbname: 'memoapp')
  conn.exec(
    "UPDATE memos SET
      title = '#{title}',
      content = '#{content}',
      updated_at = '#{current_time}'
    WHERE
      id = '#{id}'
    "
  )
end

def delete_memo(id)
  # なかった場合のエラー処理考える
  conn = PG.connect(dbname: 'memoapp')
  conn.exec(
    "DELETE from memos where id = '#{id}'"
  )
end

def fetch_memo_by_id(memos, id)
  memos.find { |memo| memo["id"] == id }
end
