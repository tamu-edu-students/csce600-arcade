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

initial_aesthtics = [
  { game_id: 1, primary_clr: '#FFFF00', secondary_clr: '#0000FF', font_clr: '#000000', font: 'Verdana, Geneva, Tahoma, sans-serif' }
]

initial_aesthtics.each do |aesthetic|
  Aesthetic.find_or_create_by!(aesthetic)
end

if Rails.env.test? then
  test_user = { first_name: 'Spongebob', last_name: 'Squarepants', email: 'spongey@tamu.edu' }
  new_user = User.find_or_create_by(test_user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")

  test_member_user = { first_name: 'Patrick', last_name: 'Star', email: 'starry@tamu.edu' }
  new_member_user = User.find_or_create_by(test_member_user)
  Role.find_or_create_by!(user_id: new_member_user.id, role: "Member")
else
  users = [
    { first_name: "Philip", last_name: "Ritchey", email: "pcr@tamu.edu" },
    { first_name: "Antonio", last_name: "Rosales", email: "antoniorosales@tamu.edu" },
    { first_name: "Junchao", last_name: "Wu", email: "junchao-wu@tamu.edu" },
    { first_name: "Kanishk", last_name: "Chhabra", email: "kanishk.chhabra@tamu.edu" },
    { first_name: "Krishna", last_name: "Calindi", email: "kxc@tamu.edu" },
    { first_name: "Nandinii", last_name: "Yeleswarapu", email: "nandiniiys@tamu.edu" },
    { first_name: "Tejas", last_name: "Singhal", email: "singhalt@tamu.edu" },
    { first_name: "Ze", last_name: "Sheng", email: "zesheng@tamu.edu" }
  ]
  users.each do |user|
    new_user = User.find_or_create_by(user)
    Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
  end
end
