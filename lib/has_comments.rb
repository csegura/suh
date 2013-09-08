module HasComments
  def self.included(base)
    base.class_eval do
      has_many :comments,
               :as => :commentable,
               :order => "created_at DESC",
               :dependent => :destroy
    end
  end

  def comments_count
    self.comments.not_in_trash.size
  end

  def users
    users = [self.user]
    comments.each { |comment| users << comment.user }
    users.uniq
  end
end