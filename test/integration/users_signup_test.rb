require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
     # 配列deliveries はメールの数を調べる際に利用。
     # setupメソッドでこれを初期化しておかないと、
     # 並行して行われる他のテストでメールが配信されたときに
     # エラーが発生してしまいます
  end

  test "invalid signup information" do
    get signup_path
  # 引数がブロック実行後も変わらないこと
    assert_no_difference('User.count')  do
      post(
        users_path,
        params: {
          user: {
            name:  "",
            email: "user@invalid",
            password:              "foo",
            password_confirmation: "bar"
          }
        }
      )
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
   # assert_select 'form[action=?]','/signup'
     assert_select 'form[action=?]','/users'
  end


  test "前後で違うパスワード" do
    get signup_path
  # 引数がブロック実行後も変わらないこと
    assert_no_difference('User.count')  do
      post(
        users_path,
        params: {
          user: {
            name:  "user",
            email: "user@email.com",
            password:              "aaaaaa",
            password_confirmation: "bbbbbb"
          }
        }
      )
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post(
        users_path,
        params: {
          user: {
            name:  "Example User",
            email: "user1@example.com",
            password:              "password",
            password_confirmation: "password"
          }
        }
      )
    end

  # リスト 11.33: ユーザー登録のテストにアカウント有効化を追加する
    # メールが配信されているか確認する。
    assert_equal 1, ActionMailer::Base.deliveries.size

    # assignsメソッドを使い、Usersコントローラーで作成された
    # インスタンス変数 @userを 変数 userに保存
    user = assigns(:user)
    assert_not user.activated?

    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?

    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?

    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

  #POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動する
    follow_redirect!

    assert_template 'users/show'

  # flash のテスト
    assert_not flash[:success].blank?
    #別パターン# assert_not flash.empty?

   # サインアップ後に自動的にログインしていること
    assert is_logged_in?,  "ログインできてないぞ"

  end

end
