class User < ApplicationRecord

  attr_accessor :remember_token,:activation_token
  # Virtual attributes ( which do not exist in database ) need to be defined with attr_accessor

  before_save  :downcase_email
  before_create :create_activation_digest

  validates :name,presence: true,length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,presence: true,
            length: {maximum: 255},
            format:{ with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,presence: true,length: {minimum: 6},allow_nil: true

  class << self
     def digest(string)
       cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
       BCrypt::Password.create(string, cost: cost)
     end

     def new_token
       SecureRandom.urlsafe_base64
     end
  end

  def authenticated?(attribute,token)
    digest = self.send("#{attribute}_digest")
    # Like we are sending this method to user
    # Fetching the digest
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest,nil)
  end

  def activate
    update_columns(activated:true,activated_at:Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest activation_token
      # As activation_digest column exists in database previously when saving this user it will get saved to database automatically
    end

    def downcase_email
      self.email.downcase!
    end

end