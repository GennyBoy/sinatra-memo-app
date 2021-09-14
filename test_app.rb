require './app'
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_top_page
    get '/'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '追加'
  end

  def test_new_page
    get '/memos/new'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '保存'
  end

  def test_show_page_notfound
    get '/memos/notfound'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '404 Not Found'
  end

  def test_show_page
    get '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b203'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'テストの本文'
  end

  def test_edit_page_notfound
    get '/memos/notfound/edit'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '404 Not Found'
  end

  def test_edit_page
    get '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b203/edit'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'テストの本文'
  end

  def test_post_memos
    post '/memos', :title => 'POSTのタイトル', :content => 'POSTのcontent'

    # 成功した場合、最後の処理がリダイレクトなのでステータスコードは302になる
    assert_equal 302, last_response.status
    # 実装側で作成されたmemoのuuidを返すようにしたい
    # それを使ってdeleteでteardownする
  end

  def test_post_memos_empty_string
    post '/memos', :title => ''

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'タイトルを入力してください'
  end

  def test_post_memos_nil
    post '/memos', :title => nil

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'タイトルを入力してください'
  end
  # これはいわば結合テストなので、単体テスト(privateのメソッドレベルでどうやってテストできるか調べる)

end
