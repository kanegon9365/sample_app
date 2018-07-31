class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {self.email = email.downcase}
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  
  
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
   
  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  #永続セッションのためにユーザーをデーターベースに保存する
  def remember
    self.remember_token = User.new_token  #ランダムに生成されたトークンが,記憶トークンに代入
    update_attribute(:remember_digest, User.digest(remember_token))  
    #一行目で生成された記憶トークンがハッシュ化され、記憶ダイジェストに代入されupdate_attributeで強制的に更新される。
  end
  
  #渡されたトークンがダイジェストと一致した場合にtrueを返す。データーベース内にあるダイジェストと生成されたトークンの比較？
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end
