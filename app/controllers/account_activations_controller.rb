class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user &&
      !user.activated? &&
        # 既に有効になっているユーザーを誤って再度有効化しないため
        # これが無いと、攻撃者がユーザーの有効化リンクを使って、
        # 本当のユーザーとしてログインできてしまう。
      user.authenticated?(:activation, params[:id])

      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
