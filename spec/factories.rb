require "factory_girl"

Factory.sequence :email do |n|
  "email_#{n}@localhost.com"
end

Factory.sequence :user_name do |n|
  "User Name ##{n}"
end

Factory.sequence :user_surname do |n|
  "Surname ##{n}"
end

Factory.sequence :company_name do |n|
  "Company ##{n}"
end

Factory.sequence :main_company_name do |n|
  "Main Company ##{n}"
end

Factory.sequence :subdomain do |n|
  "Subdomain ##{n}"
end

Factory.sequence :time do |x|
  Time.now - x.hours
end

Factory.sequence :date do |x|
  Date.today - x.days
end

Factory.define :user do |user|
  user.email    { Factory.next(:email) }
  user.password "big_secret"
  user.password_confirmation "big_secret"
end

Factory.define :company do |company|
  company.name              { Factory.next(:company_name) }
  company.main_company_id   1
end

Factory.define :main_company, :class => :company do |main|
  main.name             { Factory.next(:main_company_name) }
  main.subdomain        { Factory.next(:subdomain) }
end

Factory.define :access do |access|
  access.association    :user
  access.association    :company
end

Factory.define :avatar do |a|
  a.user                { |u| u.association(:user) }
  a.entity              { raise "Please specify :entity for the avatar" }
  a.image_file_size     nil
  a.image_file_name     nil
  a.image_content_type  nil
  a.updated_at          { Factory.next(:time) }
  a.created_at          { Factory.next(:time) }
end
