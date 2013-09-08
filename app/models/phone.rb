class Phone < ActiveRecord::Base
  belongs_to :phoneable, :polymorphic => true

  validates :name, :presence => true, :length => {:maximum => 32}
  validates :number, :presence => true, :length => {:maximum => 32}

  NAMES = %w(office mobile home fax)
end
# == Schema Information
#
# Table name: phones
#
#  id             :integer         not null, primary key
#  name           :string(32)      not null
#  number         :string(32)
#  phoneable_id   :integer
#  phoneable_type :string(255)
#  position       :integer
#

