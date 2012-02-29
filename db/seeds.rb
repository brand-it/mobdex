# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: "brandt.lareau@gmail.com", password: "password", password_confirmation: "password", first_name: "Brandt", last_name: "Lareau", access_level: 8, active: true)