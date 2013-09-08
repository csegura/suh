class Company < ActiveRecord::Base
  include HasAddressesPhones

  # main_company
  has_many :accesses
  has_many :categories
  has_many :companies, :foreign_key => "main_company_id"

  has_many :issues, :through => :accesses

  # company
  belongs_to :main_company, :class_name => "Company"
  has_one    :avatar, :as => :entity, :dependent => :destroy  # company avatar.

  validates :name, :presence => true

  validates :subdomain,
            :presence => true,
            :uniqueness => true,
            :if => lambda { |r| r.main_company_id.nil? }

  attr_accessible :name,
                  :subdomain,
                  :avatar_attributes

  accepts_nested_attributes_for :avatar, :allow_destroy => true

  # return the main company url of company
  def main_url
    if is_main?
      "#{::AppConfig.main_protocol}#{self.subdomain}.#{::AppConfig.main_domain}"
    else
      "#{::AppConfig.main_protocol}#{self.main_company.subdomain}.#{::AppConfig.main_domain}"
    end
  end

  def is_main?
    self.main_company_id.nil?
  end

  def main_company_name
    self.main_company.name
  end

  def main_company_subdomain
    self.main_company.subdomain
  end


end

# == Schema Information
#
# Table name: companies
#
#  id              :integer         not null, primary key
#  name            :string(255)     not null
#  subdomain       :string(255)
#  main_company_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

