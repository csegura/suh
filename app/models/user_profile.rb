class UserProfile < ActiveRecord::Base
  include HasAddressesPhones
end


# == Schema Information
#
# Table name: user_profiles
#
#  id        :integer         not null, primary key
#  user_id   :integer
#  title     :string(64)
#  company   :string(64)
#  alt_email :string(64)
#

