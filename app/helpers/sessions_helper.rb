module SessionsHelper

  def log_in(user)
    # sessionはRailsのメソッド。
    # セッションクッキーを保存する
    session[:user_id] = user.id
  end

end
