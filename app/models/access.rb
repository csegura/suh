class Access < ActiveRecord::Base
  include HasAddressesPhones
  cattr_reader :per_page
  @@per_page = 20

  acts_as_role :roles, :values => %w(admin owner user), :default => :user

  belongs_to :user
  belongs_to :company
  has_one :main_company, :through => :company, :class_name => "Company"

  has_many :notes, :as => :annotate, :dependent => :destroy
  has_many :issues

  scope :for_user,
        lambda { |user| where(:user_id => user.id) }

  scope :for_main_company,
        lambda { |main_company, user|
          joins(:company).where(:user_id => user.id, :companies => {:main_company_id => main_company.id}) }

  default_scope includes(:user).includes(:company)

  validates :user_id, :presence => true
  validates :company_id, :presence => true

  validates :email,
            :presence => true

  before_validation :ensure_user

  attr_accessible :user_id,
                  :company_id,
                  :roles,
                  :active,
                  :email, :first_name, :last_name,
                  :send_invitation, :invitation

  attr_accessor :send_invitation,
                :invitation

  delegate :name, :main_url, :to => :main_company, :prefix => true
  delegate :name, :to => :company, :prefix => true
  delegate :full_name, :email, :first_name, :last_name, :last_login_at, :to => :user, :prefix => true

  def full_name
    "#{user_full_name} (#{company_name})"
  end

  def ensure_user
    if self.user.nil? && !self.email.blank?
      user = User.load_or_create(:email => self.email, :first_name => self.first_name, :last_name => self.last_name)
      if user
        self.user_id = user.id
        if self.send_invitation.checked?
          user.send_invitation(self.invitation, self.company)
        end
      end
    end
  end

  # return an array with users with a determined role
  # @param company [main company to locate owners]
  # @param role [role]
  def self.roles_for_company company, role=:user
    accesses = Access.where(:company_id => company.id)
    owners = Array.new
    accesses.each { |access| owners << access.user if access.rolez.include?(role) }
    owners
  end


  # locate an user in a main_company first look access as owner then
  # find access in companies that belong to main_company
  # @param user [user to locate]
  # @param main_company [main company]
  def self.for_user_in_main_company(user, main_company)
    unless main_company.nil? || user.nil?
      access = Access.where(:company_id => main_company.id, :user_id => user.id)
      if access.empty?
        access = Access.for_main_company(main_company, user)
      end
      return access.first
    end
    nil
  end

end

# == Schema Information
#
# Table name: accesses
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  company_id :integer         not null
#  roles      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean         default(TRUE)
#  email      :string(100)
#  first_name :string(32)
#  last_name  :string(32)
#

