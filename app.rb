# frozen_string_literal: true

require 'erb'
require 'json'
require 'pg'
require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'

include ERB::Util

# 環境変数によってテストと本番でつなぎ先変えられるかな
conn = PG.connect(dbname: 'memoapp')

get '/' do
  @memos = fetch_memos(db: conn)

  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |id|
  @memo = fetch_memo(db: conn, id: id)

  if @memo.nil?
    erb :notfound
  else
    erb :show
  end
end

get '/memos/:id/edit' do |id|
  @memo = fetch_memo(db: conn, id: id)

  if @memo.nil?
    erb :notfound
  else
    erb :edit
  end
end

post '/memos' do
  title = params[:title]
  if title == '' || title.nil?
    @error_message = 'タイトルを入力してください'
    @content = params[:content]
    erb :new
  else
    insert_memo(db: conn, id: SecureRandom.uuid, title: title, content: params[:content])
    redirect to('/')
  end
end

patch '/memos/:id' do |id|
  title = params[:title]
  if title == '' || title.nil?
    @error_message = 'タイトルを入力してください'
    @memo = fetch_memo(db: conn, id: id)
    erb :edit
  else
    update_memo(db: conn, id: id, title: title, content: params[:content])
    redirect to('/')
  end
end

delete '/memos/:id' do |id|
  delete_memo(db: conn, id: id)

  redirect to('/')
end

not_found do
  erb :notfound
end

private

def fetch_memos(db: nil)
  results = db.exec('SELECT * FROM memos')
  (0..results.ntuples - 1).map { |n| results[n] }
end

def fetch_memo(db: nil, id: nil)
  db.prepare(
    'show',
    'SELECT * FROM memos WHERE id=$1'
  )

  begin
    result = db.exec_prepared('show', [id])[0]
  rescue
    result = nil
  end

  db.exec('DEALLOCATE show')
  result
end

def insert_memo(db: nil, id: nil, title: nil, content: nil)
  current_time = Time.now
  db.prepare(
    'add',
    "INSERT INTO memos (id, title, content, created_at, updated_at)
      VALUES ($1, $2, $3, $4, $5)"
  )
  db.exec_prepared('add', [id, title, content, current_time, current_time])
  db.exec('DEALLOCATE add')
end

def update_memo(db: nil, id: nil, title: nil, content: nil)
  current_time = Time.now
  db.prepare(
    'amend',
    'UPDATE memos SET title=$1, content=$2, updated_at=$3 WHERE id=$4'
  )
  db.exec_prepared('amend', [title, content, current_time, id])
  db.exec('DEALLOCATE amend')
end

def delete_memo(db: nil, id: nil)
  db.prepare(
    'delete',
    'DELETE from memos where id = $1'
  )
  db.exec_prepared('delete', [id])
  db.exec('DEALLOCATE delete')
end
