# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

# account_activationの引数にはUserオブジェクトが必要なため、
# user変数を設定し、それをUserMailer.account_activation渡す
# 同時に アカウント有効化のトークンが必要なので、user.activation_token を設定。
# activation_tokenは、DBには無い仮の値。

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation

  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
