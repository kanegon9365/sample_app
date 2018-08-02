require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup infomation" do
    get signup_path
    assert_no_difference 'User.count' do 
      post signup_path, params:{user:{ name: "",
                               email:"user@invalid",
                               password:"foo",
                               password_confirmation:"bar"}}
    end
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
  end

  test "valid signup infomation with account activation" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
     assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)  #usersコントローラーのcreateアクション内で定義された@userに、assigns(:user)とすることでtest内でも扱うことが出来るようになる
    assert_not user.activated?  #ユーザーアカウントがまだアクティベートされていないか確認
    log_in_as(user)  # 有効化していない状態でログインしてみる
    assert_not is_logged_in?   #その状態でログインされないか確認
    get edit_account_activation_path("invalid token", email: user.email)  # 有効化トークンが不正な場合
    assert_not is_logged_in?  #その状態でログインされなければtrue
    get edit_account_activation_path(user.activation_token, email: 'wrong') # トークンは正しいがメールアドレスが無効な場合
    assert_not is_logged_in?  #その状態でもログインされなければtrue
    get edit_account_activation_path(user.activation_token, email: user.email)  # 有効化トークンが正しい場合
    assert user.reload.activated?  
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
