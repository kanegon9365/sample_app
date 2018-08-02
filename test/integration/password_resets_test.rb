require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
 
 def setup
   ActionMailer::Base.deliveries.clear
   @user=users(:michael)
 end
 
 test "password resets" do
    get new_password_reset_path                                                 #パスワード変更ページへアクセス
    assert_template 'password_resets/new'                                       #ビューが表示されているか確認
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }        #無効なメールアドレスを打ち込んで送信
    assert_not flash.empty?                                                     #エラーのフラッシュが表示されていればtrue
    assert_template 'password_resets/new'                                       #再度パスワードリセットビューが読み込まれているか
    # メールアドレスが有効
    post password_resets_path,            
         params: { password_reset: { email: @user.email } }                     #有効なメールアドレスを打ち込む
    assert_not_equal @user.reset_digest, @user.reload.reset_digest              #発行した再発行ダイジェストと再度リロードしたときに異なっている事を確認
    assert_equal 1, ActionMailer::Base.deliveries.size                          #
    assert_not flash.empty?
    assert_redirected_to root_url
    # パスワード再設定フォームのテスト
    user = assigns(:user)
    
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # 無効なユーザー
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email  #inputタグに正しい名前,hidden,メールアドレスがあるか確認している
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
  
  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match "パスワードの有効期限が切れています", response.body 
  end
  
end