require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test "valid signup information" do
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
  #POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動する
    follow_redirect!

=begin メールでのアクティベーションへ変更するため一時無効化
    assert_template 'users/show'

  # flash のテスト
    assert_not flash[:success].blank?
    #別パターン# assert_not flash.empty?

   # サインアップ後に自動的にログインしていること
    assert is_logged_in?,  "ログインできてないぞ"
=end
  end

end
