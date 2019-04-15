module SessionsHelper

# 渡されたユーザーでログインする
  def log_in(user)
    # sessionはRailsメソッド。
    # セッションクッキーを保存する
    session[:user_id] = user.id
  end

 # ユーザーのセッションを永続的にする ::リスト 9.8: ユーザーを記憶する
  def remember(user)
    user.remember   # Userモデルで定義した、トークンハッシュの保存メソッド。
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

# 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

# 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    # Railsメソッド session を使用し、session[:user_id]がnilでない場合実行
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      #            ^- @current_user が nil の場合検索結果を代入

    # クッキーにIDがあれば
    elsif (user_id = cookies.signed[:user_id])

  # 分岐がテスト実行されているかを確認するために例外処理を挿入する
      # テストがパスすれば、この部分がテストされていないことがわかる
      # raise

      user = User.find_by(id: user_id)

      # user が存在し、認証できた場合。
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end

  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  # 上で定義したcurrent_user メソッドで状態を確認している
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget   # モデルのforget メソッドをコール
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)  # 上で定義してたforgetメソッドをコール
    session.delete(:user_id)
    @current_user = nil
  end

end

