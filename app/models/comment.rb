class Comment < ActiveRecord::Base
  include HasTrash
  include HasDocuments
  include BelongsToAccess

  belongs_to :commentable,
             :polymorphic => true
             #:counter_cache => true

  validates :comment, :presence => true

  attr_accessible :comment, :access_id

  after_create :mail_comment_created

  def activity
    self.commentable.activity
  end

  private

  def mail_comment_created
    #AppMailer.comment_created(self).deliver
  end

  #def self.for_resource resource
  #  Comment.unscoped {
  #    where(:commentable_type => resource.class, :commentable_id => resource.id)
  #  }
  #end

end

# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  comment          :text
#  access_id        :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#  deleted_at       :datetime
#  company_id       :integer
#

