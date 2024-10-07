# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

unless AdminUser.find_by_email('admin@example.com')
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') # if Rails.env.development?
end

%w(
    Retirement\ Planning 
    Post\ Retirement\ Finances
    Property\ Investment 
    Tax\ Planning 
    Family\ Financial\ Security
    Goal\ Planning 
    Wealth\ Inheritance 
    Investment\ Portfolio\ And\ Wealth\ Building
    Specialized\ Financial\ Advice
).each do |ct|
    Category.find_or_create_by!(title: ct, description: "Category for planning finances related to #{ct} for the user by a fiduciary financial planner")
end