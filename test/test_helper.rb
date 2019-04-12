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

end
