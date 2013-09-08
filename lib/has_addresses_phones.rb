module HasAddressesPhones
  def self.included(base)
    base.class_eval do
      has_many :addresses, :as => :addressable, :dependent => :destroy
      has_many :phones, :as => :phoneable, :dependent => :destroy

      attr_accessible :addresses_attributes,
                      :phones_attributes

      accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank
      accepts_nested_attributes_for :phones, :allow_destroy => true, :reject_if => :all_blank
    end
  end
end