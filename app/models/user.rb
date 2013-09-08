class User < ActiveRecord::Base

  include CustomSecurePassword
  custom_has_secure_password

  has_one  :avatar, :as => :entity, :dependent => :destroy  # personal avatar.
  has_many :avatars # loaded avatars
  has_one  :user_profile, :dependent => :destroy

  attr_accessible :first_name,
                  :last_name,
                  :email,
                  :password,
                  :password_confirmation,
                  :avatar,
                  :last_login_at,
                  :last_login_ip,
                  :avatar_attributes

  validates :email,
            :presence => true,
            :uniqueness => true

  before_create { generate_token(:auth_token) }

  accepts_nested_attributes_for :avatar, :allow_destroy => true

  def active?
    not self.password_digest.nil?
  end

  def self.load_or_create user_params
    user = User.find_by_email(user_params[:email]) || User.new(user_params)
    user.skip_password_validation = true
    user.save
    user
  end

  def send_password_reset
    set_password_reset_token
    UserMailer.password_reset(self).deliver
  end

  def send_invitation(text = "", company)
    set_password_reset_token
    Rails.logger.info self.password_reset_token
    UserMailer.invitation(self, text, company).deliver
  end

  # todo: invitations
  def self.invite(email, text, company)
    user = User.find_by_email(email) || User.new(:email => email)
    if user.active?
      user.send_invitation(text, company)
    else
      user.send_invitation(text, company)
    end
  end

  def full_name
    self.first_name.blank? || self.last_name.blank? ? self.email : "#{self.first_name} #{self.last_name}"
  end

  def full_email
    "\"#{full_name}\" <#{email}>"
  end

  def update_last_login(from_ip)
    self.update_attributes(:last_login_at => DateTime.now, :last_login_ip => from_ip)
  end

  private

  def set_password_reset_token
    generate_token :password_reset_token
    self.password_reset_sent_at = Time.zone.now
    self.save(:validate => false)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(100)     not null
#  first_name             :string(32)
#  last_name              :string(32)
#  password_digest        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  last_login_at          :datetime
#  last_login_ip          :string(32)
#

