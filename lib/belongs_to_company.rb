module BelongsToCompany
  def self.included(base)
    base.class_eval do
      belongs_to :company

      scope :for_company,
            lambda { |company| where(:company_id => company.id) }

      scope :for_main_company,
            lambda { |main_company| joins { :company }.where {
              (company_id.eq(main_company.id)) |
                  (company.main_company_id.eq(main_company.id)) } }

      scope :for_company_in_main_company,
              lambda { |main_company, sub_company_id| joins { :company }.
                       where { (company_id.eq(sub_company_id)) & (company.main_company_id.eq(main_company.id)) }}

    end
  end
end
