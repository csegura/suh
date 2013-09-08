require 'spec_helper'

describe "AppConfig" do

  describe "Application config should include some important values" do

    it "default content types" do
      ::AppConfig.public_methods.should include(:image_content_type)
    end

    it "main web name" do
      ::AppConfig.public_methods.should include(:main_name)
    end

    it "main web name" do
      ::AppConfig.public_methods.should include(:main_domain)
    end

    it "main subdomain" do
      ::AppConfig.public_methods.should include(:main_subdomain)
    end

    it "main protocol" do
      ::AppConfig.public_methods.should include(:main_protocol)
    end

    it "use delayed mail" do
      ::AppConfig.public_methods.should include(:delayed_mail)
    end

  end

end