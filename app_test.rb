require './app.rb'
require 'minitest/autorun'
require 'rack/test'

class AppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def get_index
    get '/'
    assert last_response.ok?
    assert_equal 'メモアプリ', last_response.body.chomp
    assert_equal '追加', last_response.body.chomp
  end

  def get_new
    get '/new'
  end
end
