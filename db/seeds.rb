# db/seeds.rb

require 'faker'

SEED_USERS_COUNT = 9

ActiveRecord::Base.transaction do
  if Rails.env.development? || Rails.env.test?
    puts "⏳ Cleaning up database (dev/test only)..."
    Like.destroy_all
    Comment.destroy_all
    Post.destroy_all
    UserFollow.destroy_all
    User.destroy_all
  end

  puts "👤 Creating users..."
  users = SEED_USERS_COUNT.times.map do
    User.create_or_find_by!(email: Faker::Internet.unique.email) do |u|
      u.username              = Faker::Internet.unique.username(specifier: 5..12)
      u.password              = "password"
      u.password_confirmation = "password"
    end
  end

  # testing user
  test_user = User.create_or_find_by!(email: "test@testing.com") do |u|
    u.username              = "test_user"
    u.password              = "password"
    u.password_confirmation = "password"
  end
  users << test_user unless users.include?(test_user)

  puts "🔀 Creating follows..."
  users.each do |follower|
    targets = (users - [ follower ]).sample(rand(2..5))
    targets.each { |followed| follower.follow(followed) }
  end

  puts "✍️ Creating posts..."
  posts = users.flat_map do |u|
    rand(3..6).times.map do
      Post.create!(
        user: u,
        body: Faker::Lorem.paragraph(sentence_count: 2)
      )
    end
  end

  puts "👍 Creating likes..."
  users.each do |u|
    posts.sample([ 10, posts.size ].min).each do |p|
      p.likes.create!(user: u) unless p.likes.exists?(user: u)
    end
  end

  puts "💬 Creating comments..."
  posts.each do |p|
    rand(2..4).times do
      p.comments.create!(
        user: users.sample,
        body: Faker::Lorem.sentence
      )
    end
  end

  puts "✅ Seeds complete!"
end
