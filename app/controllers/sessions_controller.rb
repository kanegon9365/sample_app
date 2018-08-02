class SessionsController < ApplicationController
  def new
   
  end
  
  def create
    user=User.find_by(email: params[:session][:email].downcase)# ハッシュの入れ子構造。入力されたメールアドレスのユーザーをuserに代入
    if user && user.authenticate(params[:session][:password]) # 先ほどのユーザーがおりかつ、authenticateメソッドの引数である入力されたパスワードがtrueの時
     if user.activated #ユーザーがアクティブになったとき
       log_in user  #一時sessionログイン. helperのlog_in引数に上で定義されたuserがキーとして与えられsession loginすることが出来るようになる.
       params[:session][:remember_me] == '1' ? remember(user) : forget(user) #三項演算子. paramsが1の場合にtrueで永久ログインfalseは忘れる
       redirect_back_or user #sessionのhelperで定義された。sessionに保存されたredirectページがあればそこを返す
     else
       message="アカウントが有効化されませんでした"
       message += "登録したメールアドレスをチェックしてアカウントを有効化してください"
       flash[:warning] = message
       redirect_to root_url
     end
     else
       flash.now[:danger] = "メールアドレスもしくはパスワードが正しくありません"
       render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
