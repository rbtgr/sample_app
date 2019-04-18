require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

 # fixture からユーザーログイを行う リスト 8.23
  def setup
    #       fixtures/users.yml に定義した、michael: を取得
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

 #ログインのテスト
 test "login with valid information followed by logout" do
    get login_path
    # post login_path, params: { session: { email:    @user.email,
    #                                       password: 'password' } }
    post(
      login_path,
      { params:
        { session:
          { email:    @user.email,
            password: 'password' }
        }
      })
    assert is_logged_in?       #ログインできているか
    assert_redirected_to @user #リダイレクトが正しいか
    follow_redirect!           #リダイレクトする
    assert_template 'users/show'
    # ログアウト時のリンクが表示されていないこと
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path     # delete メソッドでsessionをログアウト
    assert_not is_logged_in?       # ログアウトできていること
    assert_redirected_to root_url  # rootにリダイレクトすること

    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!               # リダイレクト実行

    # ログアウト時のリンクが表示されること
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0

  end


# リスト 9.25: [remember me] チェックボックスのテスト
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')

    assert_equal(
      cookies['remember_token'],
      assigns(:user).remember_token)

    #assert_not_empty cookies['remember_token']
    # 要注意 -----------------------------------------
    # テスト内ではcookiesメソッドにシンボルを使えない
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

end
