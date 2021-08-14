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
  memo = {:title => params[:title], :content => params[:content] }
  memos = JSON.load(File.read("db/memos/memos.json"))
  memos.push memo

  File.open("db/memos/memos.json", "w") do |f|
    f.puts JSON.pretty_generate(memos)
  end

  redirect to('/')
end



