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


end
