puts "Seeding datatbase..."
User.delete_all

puts "***** Seeding users..."
User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  password: "password",
  password_confirmation: "password",
  admin: true,
  activated: true,
  activated_at: Time.zone.now,
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now,
  )
end

puts "***** Seeding microposts..."
users = User.order(:created_at).take(6)

users.each do |user|
  50.times do
    content = Faker::Lorem.sentence(word_count: 6)
    user.microposts.create! content: content
  end
end

puts '***** Seeding user relationship...'
users = User.all
user = users.first

following = users[2..50]
followers = users[3..40]

following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
