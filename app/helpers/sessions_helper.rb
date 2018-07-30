module SessionsHelper
  
  def log_in(user)  #session_idでログインする
    session[:user_id] = user.id
  end
  
  def current_user
    @current_user||=User.find_by(id: session[:user_id])
    #current_userにインスタンス変数を代入するメソッドを定義している。インスタンス変数が空であれば代入
  end
  
  def logged_in?  
    !current_user.nil?   #current_userが存在しているときtrue 二重否定
  end
  
  def log_out 
    session.delete(:user_id)
    @current_user = nil
  end
  
end
