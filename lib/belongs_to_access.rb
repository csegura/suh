module BelongsToAccess
  def self.included(base)
    base.class_eval do
      belongs_to :access, :include => [:user, :company]

      scope :for_access,
            lambda { |access| where(:access_id => access.id) }

      scope :for_user_access,
            lambda { |user| joins(:access).where(:accesses => {:user_id => user.id}) }

      scope :for_company_access,
            lambda { |company| joins(:access).where(:access => {:company_id => company.id}) }

      scope :for_main_company_access,
            lambda { |main_company| joins { access.company }.where {
              (access.company_id.eq(main_company.id)) |
                  (access.company.main_company_id.eq(main_company.id)) } }

      has_one :user, :through => :access
      #has_one :company, :through => :access
      #has_one :main_company, :through => :company

      delegate :full_name, :email, :to => :user, :prefix => true
      delegate :full_name, :to => :access, :prefix => true
    end

  end
end