require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
  # users.yml からテスト用のユーザーを作成
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    #get users_new_url
    get signup_path
    assert_response :success
  end

# ログアウト時、ログイン画面にリダイレクトされることの確認
  test "should redirect [edit] when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect [update] when not logged in" do
    patch user_path(@user), params: { user: {
      name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

# リスト 10.24: 間違ったユーザーが編集しようとしたときのテスト
# 権限がなければroot画面にリダイレクトすることの確認
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: {
      name: @user.name,  email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

# リスト 10.34: indexアクションのリダイレクトをテストする
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect index when logged in" do
    log_in_as(@user)
    get users_path
    assert_response :success
    assert_template 'users/index'
  end

  # admin属性の変更が禁止されていることをテストする
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {user: {
      password:              'password',
      password_confirmation: 'password',
      admin: true } }
    assert_not @other_user.reload.admin?
  end

# リスト 10.61: 管理者権限の制御をアクションレベルでテストする
  # ログインしていないユーザーであれば、ログイン画面にリダイレクトされること
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  #ログイン済みではあっても管理者でなければ、ホーム画面にリダイレクトされること
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
