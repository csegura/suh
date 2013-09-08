class Issue < ActiveRecord::Base
  include BelongsToAccess
  include BelongsToCompany
  include HasComments
  include HasDocuments

  has_many :timetracks,
           :as => :trackable,
           :dependent => :nullify

  belongs_to :closed_by_user,
             :class_name => "User",
             :foreign_key => :closed_by

  STATUS = %w(all open close)

  validates :title, :presence => true

  default_scope includes(:access, :company, :comments)
  default_scope order("issues.created_at DESC")

  attr_accessible :access_id, :title, :body, :company_id, :access, :closed_at, :closed_by, :open

  scope :for_month,
        lambda { |date| where("issues.created_at between ? and ?", date, date.next_month) }

  after_create :mail_issue_created

  def close?
    !open?
  end

  def activity
    self.title
  end

  def self.create_new_issue company, access, params
    Issue.new(params) do |issue|
      issue.company = company unless params[:company_id]
      issue.access = access unless params[:access_id]
    end
  end

  def close user
    self.update_attributes({:closed_at => DateTime.now, :closed_by => user.id, :open => false})
    AppMailer.issue_closed(self).deliver
  end

  def reopen access
    self.update_attributes({:closed_at => nil, :closed_by => nil, :open => true})
    self.comments.create(:comment => I18n.t('issue.reopen'), :access_id => access.id )
  end

  def self.for_status status
    case status
      when "open"
        where(:open => true)
      when "close"
        where(:open => false)
      else
        raise "Invalid Status"
    end
  end

  def minutes
    self.timetracks.sum(:minutes)
  end

  private

  def mail_issue_created
    #AppMailer.issue_created(self).deliver
  end

end

# == Schema Information
#
# Table name: issues
#
#  id             :integer         not null, primary key
#  title          :string(255)     not null
#  body           :text
#  access_id      :integer
#  open           :boolean         default(TRUE)
#  created_at     :datetime
#  updated_at     :datetime
#  closed_by      :integer
#  closed_at      :datetime
#  comments_count :integer         default(0)
#  company_id     :integer
#

