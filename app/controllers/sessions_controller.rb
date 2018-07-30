class SessionsController < ApplicationController
  def new
  end
  
  def create
    user=User.find_by(email: params[:session][:email].downcase) # ハッシュの入れ子構造。入力されたメールアドレスのユーザーをuserに代入
    if user && user.authenticate(params[:session][:password]) # 先ほどのユーザーがおりかつ、authenticateメソッドの引数である入力されたパスワードがtrueの時
       log_in user  #一時sessionログイン. helperのlog_in引数に上で定義されたuserがキーとして与えられsession loginすることが出来るようになる.
       redirect_to user #user_url(user)と認識される
     else
       flash.now[:danger] = "メールアドレスもしくはパスワードが正しくありません"
       render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end
