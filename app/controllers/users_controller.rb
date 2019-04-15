class UsersController < ApplicationController
 # ログイン済みユーザーかどうか確認
  before_action :logged_in_user, only: [:edit, :update]
 # 正しいユーザーかどうか確認
  before_action :correct_user,   only: [:edit, :update]
   # editとupdateのアクション時、アクションの前にlogged_in_user を実行

  def show
    @user = User.find(params[:id])
    #params[:id]は文字列型の "1" ですが、
    #findメソッドでは自動的に整数型に変換されます)。
    #debugger #byebug gemによるデバッガー起動
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else # 失敗
      render 'edit'
    end
  end

#以下はクラスからは呼び出せるが、インスタンスからは呼び出せない
private
  def user_params # パラメーターのパーミッション設定
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
      # password_confirmation のパーミッションがないと
      # 同一性チェックなどが行われない
    )
  end

# beforeアクション
  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
      # current_user? ヘルパーを使わない場合
      #  redirect_to(root_url) unless @user == current_user
  end
end
