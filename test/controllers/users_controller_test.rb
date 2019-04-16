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

end
