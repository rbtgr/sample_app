module SessionsHelper

# 渡されたユーザーでログインする
  def log_in(user)
    # sessionはRailsメソッド。
    # セッションクッキーを保存する
    session[:user_id] = user.id
  end

# 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    # Railsメソッド session を使用し、session[:user_id]がnilでない場合実行
    if session[:user_id]

      # @current_user が nil の場合検索結果を代入
     @current_user ||= User.find_by(id: session[:user_id])
     # 以下の構文と同じ
      # if @current_user.nil?
      #   @current_user = User.find_by(id: session[:user_id])
      # else
      #   @current_user
      # end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  # 上で定義したcurrent_user メソッドで状態を確認している
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end

