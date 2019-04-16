require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)          # 追加
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch(
      user_path(@user),
        { params:
          { user:
            { name:  "",
              email: "foo@invalid",
              password:              "foo",
              password_confirmation: "bar" }
          }
        }
    )
    assert_template 'users/edit'

    # 演習
    assert_select 'div.alert' , "The form contains 4 errors."

  end

=begin

  test "successful edit" do
    log_in_as(@user)          # 追加
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {
      name:  name,
      email: email,
      password:              "",
      password_confirmation: "" } }
      # ユーザー名やメールアドレスを編集するときは
      # パスワードを入力せずに更新できるようにする。
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
=end
#リスト 10.29: フレンドリーフォワーディングのテスト
 # ログインしていないユーザーが編集ページにアクセスしようとしていたなら、
 # ユーザーがログインした後にはその編集ページにリダイレクトされるようにする
 # なお、リダイレクトによってeditが描画されなくなったので、該当テストを削除
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)   # <-Fail
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {
      name:  name,
      email: email,
      password:              "",
      password_confirmation: "" } }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email

  #演習 フレンドリーフォワーディングで渡されたURLに初回のみ転送されていること
    delete logout_path
    log_in_as(@user)
    assert_redirected_to @user

  end

end
