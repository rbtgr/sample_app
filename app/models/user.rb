class User < ApplicationRecord

 # アクセスメソッドを使い、仮装的な属性remember_token を作る。
  attr_accessor :remember_token, :activation_token
   # 読み込みメソッド user.remember_token と
   # 書き込みメソッド user.remember_token = xxx   が設定される。

   before_save   :downcase_email
   before_create :create_activation_digest


# Emailアドレス検証用の正規表現(ドット連続未対応)
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

# ドット連続対応済み
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

#保存前のコールバックで、メールアドレスを小文字にする
  before_save { self.email = email.downcase }
 #before_save { self.email = self.email.downcase } と同じ
 #before_save { email.downcase! }  とすることもできる

  validates :name, presence: true, length: {maximum: 50}
  validates( :email,
    presence: true,         # 空白不許可
    length: {maximum: 255}, # 最大長
    format: { with: VALID_EMAIL_REGEX },  #メールのフォーマット確認
    uniqueness: { case_sensitive: false }) #大文字小文字を区別する


  #パスワードハッシュを利用するためのメソッド
  has_secure_password

  #パスワードのバリデーション
  validates(
    :password,
      { presence: true,
        length: { minimum: 6 },
        allow_nil: true    # 値がnilの場合にバリデーションをスキップ。
        })       # リスト 10.13: パスワードが空のままでも更新できるようにする
        #validates(:password_confirmation, presence: true)

 # モデルのクラスメソッド
 #   メソッドがインスタンス不要な場合は、クラスメソッドにするのが常道。

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)

    # わかりにくいが、以下のようにもかける。
    # (1) def self.digest(string)
    # (2) class << self
    #       def digest(string)
    # selfは、通常Userのインスタンスをさすが、この場合はUserクラスを指す。
  end

  def User.new_token
    #Rubyライブラリ 22文字のランダムな文字を返す
    SecureRandom.urlsafe_base64
  end

 # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # クラスメソッド new_token でトークンを生成し、
    # attr_accessor :remember_token で定義したセッターで登録

   # remember_digest カラム にハッシュ化したトークンを保存する。
   #   update_attribute メソッドはバリデーションを素通りする。
    update_attribute(
      :remember_digest,  # remember_digest カラム
      # クラスメソッド digest でトークンをハッシュ化
      User.digest(remember_token)
    )
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # 注：このローカル変数 remember_token は、アクセサで定義した同名変数とは別。
  def authenticated?(remember_token)
    # remember_digestがnilの場合にはreturnで即座にメソッドを終了
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    #                    ^- self.remember_digest :DBの登録データ
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

private
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
      # self.email.downcase! #演習 こうもかける
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
