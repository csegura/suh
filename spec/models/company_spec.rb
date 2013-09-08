require 'spec_helper'

describe Company do

  describe "as dependent company" do
    subject { Company.new(:name => "company", :main_company_id => 1) }

    it { should validate_presence_of(:name) }
  end

  describe "as main company" do
    before do
      @company = Company.new(:name => "company", :subdomain => "subdomain")
    end
    subject { @company }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:subdomain) }
    # todo it { should validate_uniqueness_of(:subdomain) }
  end

  describe "is_main?" do
    before do
      @company = Company.new(:name => "name")
    end

    it "true if no parent" do
      @company.main_company_id.should be_nil
      @company.is_main?.should be_true
    end

    it "false if has parent" do
      @company.main_company_id = 1
      @company.is_main?.should be_false
    end
  end
end
# == Schema Information
#
# Table name: companies
#
#  id              :integer         not null, primary key
#  name            :string(255)     not null
#  subdomain       :string(255)
#  main_company_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

