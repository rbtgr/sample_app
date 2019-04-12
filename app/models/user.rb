class User < ApplicationRecord
# 参考
# validates(:name, {presence: true})
# validates :name, presence: true

# Emailアドレス検証用の正規表現(ドット連続未対応)
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

# ドット連続対応済み
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  #保存前のコールバックで、メールアドレスを小文字にする
  before_save { self.email = email.downcase }
 #before_save { self.email = self.email.downcase } と同じ
 #before_save { email.downcase! }  とすることもできる

  validates :name, presence: true, length: {maximum: 50}
  validates :email,
    presence: true,         # 空白不許可
    length: {maximum: 255}, # 最大長
    format: { with: VALID_EMAIL_REGEX },  #メールのフォーマット確認
    uniqueness: { case_sensitive: false } #大文字小文字を区別する

  has_secure_password #パスワードハッシュを利用するためのメソッド

  #パスワードのバリデーション
  validates(
    :password,
    presence: true,
    length: { minimum: 6 }
    )

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
    BCrypt::Engine::MIN_COST :  BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end

end
