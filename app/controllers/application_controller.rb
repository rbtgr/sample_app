class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #session_helper を全てのcontrollerで利用できるようにする
  include SessionsHelper

  def hello
    render html:"hello,world!!"
  end
end
