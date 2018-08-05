require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
 include ApplicationHelper
 
 def setup
  @user=users(:michael)
 end
 
   test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name) #タイトル
    assert_select 'h1', text: @user.name  #ユーザー名が表示されているか
    assert_select 'h1>img.gravatar'   #画像が表示されているか  
    assert_match @user.microposts.count.to_s, response.body  #投稿数カウントが、response.body(ブラウザに表示されるhtmlファイル)とマッチしているかのテスト
    assert_select 'div.pagination',count: 1   #ページネーションがあるか
    @user.microposts.paginate(page: 1).each do |micropost|  
      assert_match micropost.content, response.body  #投稿がhtmlファイルの中身とマッチしているかチェックしている.
    end
  end
 
end
