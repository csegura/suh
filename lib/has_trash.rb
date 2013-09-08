module HasTrash
  def self.included(base)
    base.class_eval do
      scope :not_in_trash, where(:deleted_at => nil)
      scope :in_trash, where {:deleted_at != null}

      #default_scope where(:deleted_at => nil)
    end
  end

  def move_to_trash
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  def in_trash?
    self.deleted_at.present?
  end

  def restore_from_trash
    self.update_attribute(:deleted_at, nil)
  end
end