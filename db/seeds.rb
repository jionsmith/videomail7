# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# create accounts
admin1 = Account.create(email: "admin1@email.com", password: "defaultpw")
admin1.add_role("admin")
admin1.save

account1 = Account.create(email: "account1@email.com", password: "defaultpw")

#create categories
default = Category.create(name: 'Default')
sports = Category.create(name: 'Sports')
birthday = Category.create(name: 'Birthday')

football = Category.create(name: 'Football')
football.parent = sports
football.save

swimming = Category.create(name: 'Swimming')
swimming.parent = sports
swimming.save