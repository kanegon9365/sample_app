class MicropostsController < ApplicationController
  before_action :logged_in_user, only:[:create,:destroy]
  before_action :correct_user, only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)  #作成された投稿を@micropostに代入
    if @micropost.save
      flash[:success] = "ツイートが投稿されました"
      redirect_to root_url  
    else
      @feed_items=[]
      render 'static_pages/home'  #ホームのページに代入
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "ツイートが削除されました"
    redirect_to request.referrer || root_url
  end
  
  private
  
   def micropost_params   #storongparametersを用いることでマイクロポストのcontentだけがweb経由で変更できるようになっている
     params.require(:micropost).permit(:content, :picture)  #requireでpostのmicropostキーで受け取り、permitでcontentカラムだけを受け取るように設定している.
   end
   
   def correct_user  #findメソッドを呼び出すことで、現在のユーザが削除対象のマイクロポストを保有しているか確認している。
     @micropost = current_user.microposts.find_by(id: params[:id])
     redirect_to root_url if @micropost.nil?
   end
  
end
