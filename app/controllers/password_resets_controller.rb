class PasswordResetsController < ApplicationController
  
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create   
   @user = User.find_by(email: params[:password_reset][:email].downcase)  #newフォームで入力されたメールアドレスでデーターベースからユーザーを探す
    if @user
      @user.create_reset_digest   #ユーザーが存在する場合に再設定用ダイジェストを作成する
      @user.send_password_reset_email   #再設定メールを送信する(再設定トークンつき)
      flash[:info] = "送られたメールを確認してください"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが存在しません"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?                  # (3) への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)          # (4) への対応
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードが正常に変更されました"
      redirect_to @user
    else
      render 'edit'                                     # (2) への対応
    end
  end
  
  private
   
   def user_params
      params.require(:user).permit(:password, :password_confirmation)
   end

   
   def get_user
     @user=User.find_by(email: params[:email])
   end
   
   def valid_user
     unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
     #上はユーザーが存在し、かつ有効化されており、かつ認証済みである事を確認している。
     redirect_to root_url
     end
   end
   
   def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワードの有効期限が切れています"
        redirect_to new_password_reset_url
      end
   end
   
   
      
        
     
end
