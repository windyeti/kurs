# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# [{period: "1", price: 100}, {period: "30", price: 600}, {period: "180", price: 1000}, {period: "навсегда", price: 3000}].each { |plan| Payplan.create!(plan) }
User.create(email: 'yegor.tikhanin@gmail.com', password: '123456', password_confirmation: "123456", role: 'Admin', subdomain: "egor_shop", name: "Egor")
User.create(email: 'soharta@list.ru', password: '123456', password_confirmation: "123456", subdomain: "soharta_shop", name: "Soharta")
Payplan.create(period: "12", price: 125, for: "ReviewIntegration")
