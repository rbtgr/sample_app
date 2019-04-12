class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #params[:id]は文字列型の "1" ですが、
    #findメソッドでは自動的に整数型に変換されます)。

    #debugger
    #byebug gemによるデバッガー起動

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) #
   #@user = User.new(params[:user]) ではパーミッションがないためエラー

    if @user.save  #保存処理の成否
      #正常系
      log_in (@user) #ヘルパーでログイン
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
        # redirect_to user_url(@user) と同等
    else #失敗時の処理
      render 'new'
    end
  end

#以下はクラスからは呼び出せるが、インスタンスからは呼び出せない
private
  def user_params # パラメーターのパーミッション設定
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmaiton
    )
  end

end
