class Avatar < ActiveRecord::Base
  STYLES = { :large => "75x75#", :medium => "50x50#", :small => "25x25#", :thumb => "16x16#" }.freeze

  belongs_to :user
  belongs_to :company

  belongs_to :entity, :polymorphic => true

  # We want to store avatars in separate directories based on entity type
  # (i.e. /avatar/User/, /avatars/Lead/, etc.), so we are adding :entity_type
  # interpolation to the Paperclip::Interpolations module.  Also, Paperclip
  # doesn't seem to care preserving styles hash so we must use STYLES.dup.
  #----------------------------------------------------------------------------
  Paperclip::Interpolations.module_eval do
    def entity_type(attachment, style_name = nil)
      attachment.instance.entity_type
    end
  end
  has_attached_file :image, :styles => STYLES.dup, :url => "/avatars/:entity_type/:id/:style_:filename", :default_url => "/images/avatar.jpg"

  # Invert STYLES hash removing trailing #.
  #----------------------------------------------------------------------------
  def self.styles
    Hash[STYLES.map{ |key, value| [ value[0..-2], key ] }]
  end

  def has_image?
    not self.image_file_name.blank?
  end

  def url(style=:thumb)
    self.image.url(style)
  end

  def content_type
    self.image_content_type
  end

  def file_name
    self.image_file_name
  end
end
# == Schema Information
#
# Table name: avatars
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  entity_id          :integer
#  entity_type        :string(255)
#  image_file_size    :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

