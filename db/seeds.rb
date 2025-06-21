# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts "Cleaning up database..."
Like.delete_all
Comment.delete_all
Post.delete_all
UserFollow.delete_all
User.delete_all

puts "Creating users..."
users = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    username: Faker::Internet.unique.username(specifier: 5..12),
    password: "password123",
    password_confirmation: "password123"
  )
end

puts "Creating follows..."
users.each do |user|
  followed = users.sample(rand(2..5)) - [ user ]
  followed.each do |followed_user|
    UserFollow.find_or_create_by!(user_id: user.id, follow_id: followed_user.id)
  end
end

puts "Creating posts..."
posts = users.flat_map do |user|
  rand(3..6).times.map do
    Post.create!(
      user: user,
      body: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end
end

puts "Creating likes..."
users.each do |user|
  liked_posts = posts.sample(rand(5..10))
  liked_posts.each do |post|
    Like.create!(user: user, post: post)
    post.increment!(:likes_count)
  end
end

puts "Creating comments..."
posts.each do |post|
  rand(2..4).times do
    Comment.create!(
      user: users.sample,
      post: post,
      body: Faker::Lorem.sentence
    )
  end
end

puts "Done!"
