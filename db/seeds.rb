# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# 100.times do |i|
  
#   User.create(
#     username: "user#{i}",
#     password: "password#{i}",
#     password_confirmation: "password#{i}",
#     email: "user#{i}@example.com"
#   )

#   event = Event.new(
#     title: "event#{i}",
#     start_date: Time.now + (i+1).days,
#     description: "Description for event#{i}",
#     is_public: (i % 2) == 1,
#     owner_id: (i+1)
#   )
#   event.save!
# end

user_inserts = []
event_inserts = []

user_count = 1000
event_count = 10000

user_count.times do |i|
  password = "password#{i}"
  new_hashed_password = User.new(:password => password).encrypted_password
  user_inserts.push "('user#{i}', 'user#{i}@example.com', '#{new_hashed_password}', '#{Time.now}', '#{Time.now}')"
end

event_count.times do |i|
  owner_id = rand(1..user_count)
  event = %{
    ('event#{i}', 
    '#{Time.now + (i+1).days}', 
    'Description for event#{i}', 
    '#{(i % 2) == 1}' 
    '#{owner_id}' 
    '#{Time.now}', 
    '#{Time.now}')
  }.squish
  puts event
  event_inserts.push(event)
end

users_sql = %{
  INSERT INTO users 
  (username, email, encrypted_password, created_at, updated_at) 
  VALUES #{user_inserts.join(", ")}
}.squish

events_sql = %{
  INSERT INTO events 
  (title, start_date, description, is_public, owner_id, created_at, updated_at)
  VALUES #{event_inserts.join(", ")}
}

User.connection.execute users_sql
Event.connection.execute events_sql

