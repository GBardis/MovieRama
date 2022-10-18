# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

3.times do
  name = Faker::Name.unique.name.split(" ")
  User.create(first_name: name.first, last_name: name.second, email: Faker::Internet.email, password: "123123", password_confirmation: "123123")
end

users = User.all
20.times do
  user =  users.sample
  Movie.create!(title: Faker::Movie.title, description: Faker::Movie.quote, user_id: user.id, user_name: user.full_name )
end