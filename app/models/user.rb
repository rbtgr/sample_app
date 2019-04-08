class User < ApplicationRecord
# 参考
# validates(:name, {presence: true})
# validates :name, presence: true

  # Emailアドレス検証用の正規表現(ドット連続未対応)
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # ドット連続対応済み
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i


  validates :name, presence: true, length: {maximum: 50}
  validates :email,
    presence: true,
    length: {maximum: 255},
    format: { with: VALID_EMAIL_REGEX }
end
