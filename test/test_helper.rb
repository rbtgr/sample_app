ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # 5.3.4 演習
  include ApplicationHelper

  # テストユーザーがログイン中の場合にtrueを返す
    # <リスト 8.26> ヘルパーメソッドはtestからは呼び出せない。
    # Railsメソッド session は利用可能。
    # logged_in? ヘルパーメソッドとはあえて別の名前を設定している。
  def is_logged_in?
   #session の :user_id がnilならばfalse
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする
    # log_inメソッドと混同しないこと
  def log_in_as(user)
    session[:user_id] = user.id
  end

end

# 結合テスト用のヘルパーに追加
# 統合テストではsessionを直接取り扱うことができないので、
# 代わりにSessionsリソースに対してpostを送信することで代用

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end