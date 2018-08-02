module SessionsHelper
  
  def log_in(user)  #session_idでログインする
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user==current_user
  end
  
  def current_user  
    if (user_id = session[:user_id])            #if ユーザーidにユーザーidセッション(一時的なログイン)を代入しidセッションが存在すれば true。
      @current_user||=User.find_by(id: user_id) #current_userにインスタンス変数を代入するメソッドを定義している。インスタンス変数が空であれば代入
    elsif (user_id = cookies.signed[:user_id])  #ifでなければ、ユーザidにクッキーを用いた永続ログインを代入しあればtrue
     
      user = User.find_by(id: user_id)          #userにデーターベースから永続ログインされたidを代入
      if user && user.authenticated?(:remember, cookies[:remember_token])  #idが存在しandクッキーに記憶トークンがあればtrue
        log_in user                             #永続ログインのユーザーでログインする
       @current_user = user
      end
    end
  end
  
  def logged_in?  
    !current_user.nil?   #current_userが存在しているときtrue 二重否定
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)  #session[:forwarding]がnilで無ければそのページを返し、そうでなければデフォルトページを返す
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get? 
    #リクエストが送られたurlをsession変数のforwardingキーに格納している。request.original_urlでリクエスト先が取得できる
  end
  
end
