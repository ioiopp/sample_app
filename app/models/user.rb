# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  # presence: true ommited for :password, to avoid duplicate information when sign up fails
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  # a spec problem
  #if Rails.env.test?
  #  def password_digest=(digest)
  #    @password_digest = digest
  #  end
  #
  #  def password_digest
  #    @password_digest
  #  end
  #end

end


