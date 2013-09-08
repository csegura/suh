module HasDocuments
  def self.included(base)
    base.class_eval do
      has_many :documents,
               :as => :attachable,
               :dependent => :destroy

      attr_accessible :documents_attributes

      accepts_nested_attributes_for :documents, :allow_destroy => true, :reject_if => :all_blank
    end
  end
end