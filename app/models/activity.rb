class Activity < ActiveRecord::Base
  include BelongsToAccess

  cattr_reader :per_page
  @@per_page = 20

  belongs_to :user
  belongs_to :company

  belongs_to :subject, :polymorphic => true

  has_many :activity_reads
  has_many :users, :through => :activity_reads, :as => :readers

  default_scope includes(:access)
  default_scope includes(:activity_reads)
  default_scope order("activities.created_at DESC")

  scope :for_user,
        lambda { |user| joins { :access }.where { (user_id.eq(user.id)) | (access.user_id.eq(user.id)) } }
  scope :for_company,
        lambda { |company, user| joins { :access }.where { (company_id.eq(company.id)) | (access.company_id.eq(company.id)) |
            (user_id.eq(user.id)) | (access.user_id.eq(user.id)) } }
  scope :for_main_company,
        lambda { |main_company| joins { :company }.where { (company_id.eq(main_company.id)) |
            (company.main_company_id.eq(main_company.id)) } }

  scope :for_company_in_main_company,
        lambda { |main_company, sub_company_id| joins { :company }.
                 where { (company_id.eq(sub_company_id)) & (company.main_company_id.eq(main_company.id)) }}

  scope :for_activity,
        lambda { |activity| where(:subject_type => activity) }
  scope :for_month,
        lambda { |date| where("activities.created_at between ? and ?", date, date.next_month) }

  scope :read,
        lambda {|user| joins {:activity_reads}.where { activity_reads.user_id.eq(user.id) } }

  scope :unread,
        lambda {|user| joins {activity_reads.outer}.where { activity_reads.user_id.not_eq(user.id) |
                                                             activity_reads.activity_id.eq(nil) }}

  ASSETS = %w(issue comment document).inject([]) { |arr, asset| arr << [asset, I18n.t("activity.activity.#{asset}")] }

  # ====================

  def is_read?(user_id)
    if activity_reads.empty?
      false
    else
      Rails.logger.info "**"
      activity_reads.exists? :user_id => user_id
      # find_by_user_id(user_id) != nil
    end
  end

  def mark_read(user_id)
    activity_reads.create :user_id => user_id
  end

  def mark_unread(user_id)
    if is_read?(user_id)
      activity_reads.find_by_user_id(user_id).destroy
    end
  end

  def self.log(subject, access, company_id, user_id, action)
    if action != :viewed
      create_activity(subject, access, company_id, user_id, action)
    end

    if action == :deleted
      # Remove the subject from recently viewed list. Note that we don't
      # specify an user since we want to delete :viewed activity for all users.
      #delete_activity(nil, subject, :viewed)
    end

    if [:viewed, :updated, :commented].include?(action)
      #  update_activity(user, subject, :viewed)
    end
  end

  def self.load_activities access
    if access.is_owner?
      Rails.logger.info "as owner #{access.company_name}"
      Activity.for_main_company(access.company)
    elsif access.is_admin?
      Rails.logger.info "as admin #{access.company_name}"
      Activity.for_company(access.company, access.user)
    else
      Activity.for_user(access.user)
    end
  end

  private

  def self.create_activity(subject, access, company_id, user_id, action)
    create(:access_id => access.id,
           :company_id => company_id,
           :user_id => user_id,
           :action => action.to_s,
           :subject => subject,
           :info => subject.activity)
  end

  #def self.update_activity(subject, action)
  #  activity = Activity.first(:conditions => ["user_id=? AND subject_id=? AND subject_type=? AND action=?",
  #                                            user.id, subject.id, subject.class.name, action.to_s])
  #  if activity
  #    activity.update_attribute(:updated_at, Time.now)
  #  else
  #    create_activity(user, nil, nil, nil, subject, action)
  #  end
  #end

end
# == Schema Information
#
# Table name: activities
#
#  id           :integer         not null, primary key
#  access_id    :integer
#  user_id      :integer
#  company_id   :integer
#  subject_id   :integer
#  subject_type :string(255)
#  action       :string(32)      default("created")
#  info         :string(255)     default("")
#  private      :boolean         default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#

