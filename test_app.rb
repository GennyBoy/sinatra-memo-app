require './app'
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # def setup
  #   @memos = [{"id"=>"fc2558b9-cd44-42a2-96e2-67acc0e9b483", "title"=>"<strong>strong</strong>", "content"=>"改行\r\n<br>2行目</br>\r\n3行目", "created_at"=>"2021-08-31 07:45:51", "updated_at"=>"2021-08-31 07:47:26"}, {"id"=>"6bcdc9cd-d8fa-4046-8502-2d5975a3862c", "title"=>"fff", "content"=>"fff", "created_at"=>"2021-08-31 07:47:38", "updated_at"=>"2021-08-31 07:47:38"}, {"id"=>"a9955ddf-507e-494b-9820-18377d7f62f9", "title"=>"jjj", "content"=>"1\r\n2\r\n3\r\n4\r\n5\r\n", "created_at"=>"2021-08-31 07:48:54", "updated_at"=>"2021-08-31 07:50:44"}, {"id"=>"4c8f0d4a-cd60-42b8-83f2-b75c38c213b2", "title"=>"ggg", "content"=>"gggg", "created_at"=>"2021-08-31 07:51:46", "updated_at"=>"2021-08-31 07:51:46"}, {"id"=>"0caa06c0-7191-4247-9a37-2e9436f45367", "title"=>"ggggg", "content"=>"1\r\n\r\n2\r\n\r\n3\r\n4\r\n5", "created_at"=>"2021-08-31 07:52:32", "updated_at"=>"2021-08-31 07:52:32"}, {"id"=>"0fc66236-1150-42de-b4ad-fe9808e8b04e", "title"=>"kaigyou test", "content"=>"1行目\r\n2行目\r\n\r\n3行目", "created_at"=>"2021-09-04 16:41:38", "updated_at"=>"2021-09-04 16:41:38"}]
  #   @memo = {"id"=>"c58668db-74aa-4025-b7ba-1a5d72f6b203", "title"=>"これはテストのタイトルです", "content"=>"これはテストの本文です\r\nこれは二行目です。", "created_at"=>"2021-09-06 20:54:44", "updated_at"=>"2021-09-06 20:54:44"}
  # end

  # テストデータどうやって突っ込むか考える
  # そもそも何をテストすべきか考える
  # 例えばトップ画面だと、メモがある場合とない場合とか？

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
    assert_includes last_response.body, 'これはテストの本文です'
  end

  def test_edit_page_notfound
    get '/memos/notfound/edit'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '404 Not Found'
  end

  def test_edit_page
    get '/memos/c58668db-74aa-4025-b7ba-1a5d72f6b203/edit'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'これはテストの本文です'
  end

  def test_post_memos
    post '/memos', :title => 'POSTのタイトル', :content => 'POSTのcontent'

    # 成功した場合、最後の処理がリダイレクトなのでステータスコードは302になる
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
  # これはいわば結合テストなので、単体テスト(privateのメソッドレベルでどうやってテストできるか調べる)
end
