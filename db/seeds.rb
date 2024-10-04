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

initial_users = [
  { first_name: 'Krishna', last_name: "Calindi", email: "kxc@tamu.edu", uid: 1 },
  { first_name: "Philip", last_name: "Ritchey", email: "pcr@tamu.edu", uid: 0 }
]

initial_users.each do |user|
  new_user = User.find_or_create_by(user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
end
