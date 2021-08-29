# frozen_string_literal: true

require 'erb'
require 'json'
require 'pg'
require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'

include ERB::Util

conn = PG.connect(dbname: 'memoapp')

get '/' do
  @memos = fetch_memos(db: conn)

  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |id|
  memos = fetch_memos(db: conn)

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
  insert_memo(db: conn, id: SecureRandom.uuid, title: params[:title], content: params[:content])

  redirect to('/')
end

patch '/memos/:id' do |id|
  update_memo(db: conn, id: id, title: params[:title], content: params[:content])

  redirect to('/')
end

delete '/memos/:id' do |id|
  delete_memo(db:conn, id: id)

  redirect to('/')
end

not_found do
  erb :notfound
end

private

def fetch_memos(db: nil)
  results = db.exec(
    "SELECT * FROM memos"
  )
  (0..results.ntuples-1).map { |n| results[n] }
end

def insert_memo(db: nil, id: nil, title: nil , content: nil)
  current_time = Time.now
  db.prepare('insert', "INSERT INTO memos (
      id, title, content, created_at, updated_at
    )
    VALUES
    (
      $1, $2, $3, $4, $5
    )"
  )
  db.exec_prepared('insert', [id, title, content, current_time, current_time])
end

def update_memo(db: nil, id: nil, title: nil , content: nil)
  current_time = Time.now
  db.exec(
    "UPDATE memos SET
      title = '#{title}',
      content = '#{content}',
      updated_at = '#{current_time}'
    WHERE
      id = '#{id}'
    "
  )
end

def delete_memo(db: nil, id: nil)
  # なかった場合のエラー処理考える
  db.exec(
    "DELETE from memos where id = '#{id}'"
  )
end

def fetch_memo_by_id(memos, id)
  memos.find { |memo| memo["id"] == id }
end
