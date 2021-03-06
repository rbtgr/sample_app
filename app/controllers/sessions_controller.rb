class SessionsController < ApplicationController
  def new
    # debugger # デバッガを起動するメソッド
  end

# 演習9.3.1.1  assign メッソドを使うため user -> @user
  def create
    # user -> @user
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])

=begin
      # user  : find_byの該当があればモデルオブジェクト、なければnil
      # user.authenticate(xxx) :
      #             パスワード一致ならモデルオブジェクト、なければnil
      log_in(@user) # session helper
       # session の :user_id に、userのid値を保存

      if params[:session][:remember_me] == '1'
        remember(@user)
      else
        forget(@user)
      end
      # 三項演算子で以下のようにも書ける。
      # params[:session][:remember_me] == '1' ? remember(user) : forget(user)

    # 記憶したURL (もしくはデフォルト値) にリダイレクト
      redirect_back_or @user
        # リスト 10.32 では user
    #  redirect_to @user
    #  redirect_to user_url(user) と同じ
=end

   #  リスト 11.32: 有効でないユーザーがログインすることのないようにする
   #  注 userを @userにする必要あり
    if @user.activated?
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_url
    end

  else
    # エラーメッセージ
      #表示したテンプレートをrenderメソッドで強制的に再レンダリングしても
      #リクエストと見なされないため、リクエストのメッセージが消えない
      #この場合、flash.now とすれば、現在のActionのみ有効になる
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? # ログイン状態でのみログアウトする
    redirect_to root_url
  end

end
