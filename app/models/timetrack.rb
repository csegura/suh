class Timetrack < ActiveRecord::Base
  include BelongsToAccess
  include BelongsToCompany
  include HasTrash

  belongs_to :trackable,
             :polymorphic => true

  belongs_to :confirmed_by_access,
             :class_name => "Access",
             :foreign_key => :confirmed_by

  before_save :set_access_and_company
  after_create :mail_timetrack_created

  default_scope order("tracked_at DESC")

  scope :for_status,
        lambda {|confirmed| where(:confirmed => (confirmed == "confirmed")) }
  scope :for_month,
        lambda { |date| where("issues.created_at between ? and ?", date, date.next_month) }

  scope :in_last_week, where("created_at > ?", 1.week.ago)
  scope :in_last_month, where("created_at > ?", 1.month.ago)
  scope :months_ago, lambda { |lambda| where("created_at > ? AND created_at < ?", lambda.months.ago.beginning_of_month, (lambda - 1).months.ago.beginning_of_month) }
  scope :since, lambda { |lambda| where("created_at > ?", lambda) }

  #sum hours scopes
  def self.hours_today
    self.since(Time.now.beginning_of_day).sum(:minutes)
  end

  def self.hours_this_week
    self.since(Time.now.beginning_of_week).sum(:minutes)
  end

  def self.hours_this_month
    self.since(Time.now.beginning_of_month).sum(:minutes)
  end

  def activity
    self.trackable.activity
  end

  def confirm access
    self.update_attributes({:confirmed_at => DateTime.now, :confirmed_by_access => access, :confirmed => true})
    mail_timetrack_created
  end

  def brothers
    current_timetrack_id = self.id
    self.trackable.timetracks.where { id != current_timetrack_id }
  end

  private

  def mail_timetrack_created
    #AppMailer.timetrack_created(self).deliver
  end

  def set_access_and_company
    self.company_id = self.trackable.company_id
    self.access_id = self.trackable.access_id
  end

end
# == Schema Information
#
# Table name: timetracks
#
#  id             :integer         not null, primary key
#  access_id      :integer
#  company_id     :integer
#  body           :text
#  confirmed      :boolean         default(FALSE)
#  confirmed_by   :integer
#  confirmed_at   :datetime
#  tracked_at     :datetime
#  deleted_at     :datetime
#  minutes        :integer
#  trackable_id   :integer
#  trackable_type :string(255)
#  billable       :boolean         default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  tracked_by     :integer
#

