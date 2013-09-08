class Document < ActiveRecord::Base
  include BelongsToAccess
  include BelongsToCompany
  include HasComments

  belongs_to :attachable, :polymorphic => true

  belongs_to :category

  default_scope order("created_at DESC")

  before_save :ensure_access_and_company

  scope :for_month,
         lambda { |date| where("documents.created_at between ? and ?", date, date.next_month) }

  scope :for_category_id,
           lambda { |id| where(:category_id => id) }


  has_attached_file :asset,
                    :styles => {:medium => "150x150>",
                                :thumb => "40x40>"}

  validates :asset_file_name,
            :presence => true

  attr_accessible :category_id, :asset, :company_id

  before_post_process :is_image?

  def self.create_new company, access, params
    Rails.logger.info params.inspect
    Document.new(params) do |document|
      document.company = company unless params[:company_id]
      document.access = access
    end
  end

  def is_image?
    ::AppConfig.image_content_type.split(',').include?(self.asset_content_type)
  end

  def url(style=:thumb)
    self.asset.url(style)
  end

  def content_type
    self.asset_content_type
  end

  def file_name
    self.asset_file_name
  end

  def file_size
    self.asset_file_size
  end

  def exist?
    not self.asset.nil?
  end

  def path
    self.asset_content_type.path
  end

  def activity
    self.asset_file_name
  end

  private

  def ensure_access_and_company
    if self.access.nil?
      self.access = attachable.access
    end
    if self.company.nil?
      if attachable.is_a?(Comment)
        self.company_id = attachable.commentable.company_id
      else
        self.company_id = attachable.company_id
      end
    end
  end

end
# == Schema Information
#
# Table name: documents
#
#  id                 :integer         not null, primary key
#  access_id          :integer
#  company_id         :integer
#  category_id        :integer
#  comment            :text
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#  attachable_type    :string(255)
#  attachable_id      :integer
#  created_at         :datetime
#  updated_at         :datetime
#

