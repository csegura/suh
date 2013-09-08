class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true

  validates :code, :numericality => true

  attr_accessible :name, :line1, :line2, :city, :state, :code, :country
end

# == Schema Information
#
# Table name: addresses
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  line1            :string(255)
#  line2            :string(255)
#  city             :string(128)
#  state            :string(128)
#  code             :integer
#  country          :string(128)
#  addressable_id   :integer
#  addressable_type :string(255)
#  position         :integer
#

