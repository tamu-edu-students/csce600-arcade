# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

initial_games = [
    { name: 'Spelling Bee', game_path: 'spellingbee_path' },
    { name: 'Wordle', game_path: 'wordle_path' },
    { name: 'Letter Boxed', game_path: 'letterboxed_path' }
]

initial_games.each do |game|
    Game.find_or_create_by!(game)
end

if Rails.env.development?
  user = { first_name: 'Krishna', last_name: "Calindi", email: "kxc@tamu.edu", uid: 0 }
  new_user = User.find_or_create_by(user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
end

if Rails.env.production?
  user = { first_name: "Krishna", last_name: "Calindi", email: "kxc@tamu.edu", uid: 0 }
  new_user = User.find_or_create_by(user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
end

if Rails.env.test?
  test_user = { first_name: 'Spongebob', last_name: 'Squarepants', email: 'spongey@tamu.edu', uid: 0 }
  new_user = User.find_or_create_by(test_user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")

  test_member_user = { first_name: 'Patrick', last_name: 'Star', email: 'starry@tamu.edu', uid: 1 }
  new_member_user = User.find_or_create_by(test_member_user)
  Role.find_or_create_by!(user_id: new_member_user.id, role: "Member")
end
