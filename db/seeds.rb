# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(:email => "csegura@ideseg.com", :password => "12345678")
c = Company.create(:name => "IDESEG", :subdomain => "ideseg")
a = Access.create(:user_id => u.id, :company_id => c.id, :email => u.email)
a.add_roles :owner
a.save
