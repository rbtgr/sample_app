class UsersController < ApplicationController
 # ログイン済みユーザーかどうか確認
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
 # 正しいユーザーかどうか確認
  before_action :correct_user,   only: [:edit, :update]
   # editとupdateのアクション時、アクションの前にlogged_in_user を実行

   before_action :admin_user, only: :destroy

  def index
      # @users = User.all  # ページネーションを使わない場合。
    @users = User.paginate(page: params[:page])
    # ページネーション :params[:page] は will_paginateによって自動生成される。

    # 演習 リスト 11.40: 有効なユーザーだけを表示するコードのテンプレート
    # @users = User.where(activated: true).paginate(page: params[:page])

  end

  def show
    @user = User.find(params[:id])
    #params[:id]は文字列型の "1" ですが、
    #findメソッドでは自動的に整数型に変換されます)。
    #debugger #byebug gemによるデバッガー起動

    # 演習 リスト 11.40: 有効なユーザーだけを表示するコードのテンプレート
    redirect_to root_url and return unless @user.activated?
    # &&演算子の方がandよりも優先順位が高い
    # redirect_to (root_url && return unless @user )
    # (redirect_to root_url)  &&  return unless @user

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
   #@user = User.new(params[:user]) ではパーミッションがないためエラー

    if @user.save  #保存処理の成否
    #正常系
     # メーラーアクティベーションを使わない場合
      # log_in (@user) #ヘルパーでログイン
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user # redirect_to user_url(@user) と同等

      @user.send_activation_email # メール送信
       # UserMailer.account_activation(@user).deliver_now
       # メール送信はUsersモデルのメソッドに移管した

      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
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
     # Sessions Helper アクセスしようとしたURLを覚えておく
      store_location
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

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
