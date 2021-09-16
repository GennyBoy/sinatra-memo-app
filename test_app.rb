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

    assert_equal 302, last_response.status
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

  def test_patch_memo
    patch '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b204', :title => '更新したタイトル', :content => '更新した本文'

    # 成功した場合、最後の処理がリダイレクトなのでステータスコードは302になる
    assert_equal 302, last_response.status
  end

  def test_patch_memo_empty_string_title
    patch '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b204', :title => '', :content => '更新した本文'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'タイトルを入力してください'
  end

  def test_patch_memo_nil_title
    patch '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b204', :title => nil, :content => '更新した本文'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'タイトルを入力してください'
  end

  def test_delete_memo
    delete '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b205'

    assert_equal 302, last_response.status
  end
end
