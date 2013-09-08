class ActivityRead < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user
end
# == Schema Information
#
# Table name: activity_reads
#
#  id          :integer         not null, primary key
#  activity_id :integer
#  user_id     :integer
#

