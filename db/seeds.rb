## add initial games to the database
initial_games = [
    { name: 'Spelling Bee', game_path: 'spellingbee_path' },
    { name: 'Wordle', game_path: 'wordle_path' },
    { name: 'Letter Boxed', game_path: 'letterboxed_path' }
]

initial_games.each do |game|
  unless Game.exists?(name: game[:name])
    Game.create!(game)
  end
end

## add test users to the test database and all developers as system admins to the prod database
if Rails.env.test? then
  test_user = { first_name: 'Spongebob', last_name: 'Squarepants', email: 'spongey@tamu.edu', uid: 0 }
  new_user = User.find_or_create_by(test_user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")

  test_member_user = { first_name: 'Patrick', last_name: 'Star', email: 'starry@tamu.edu', uid: 1 }
  new_member_user = User.find_or_create_by(test_member_user)
  Role.find_or_create_by!(user_id: new_member_user.id, role: "Member")
else
  users = [
    { first_name: "Philip", last_name: "Ritchey", email: "pcr@tamu.edu", uid: 0 },
    { first_name: "Antonio", last_name: "Rosales", email: "antoniorosales@tamu.edu", uid: 1 },
    { first_name: "Junchao", last_name: "Wu", email: "junchao-wu@tamu.edu", uid: 2 },
    { first_name: "Kanishk", last_name: "Chhabra", email: "kanishk.chhabra@tamu.edu", uid: 3 },
    { first_name: "Krishna", last_name: "Calindi", email: "kxc@tamu.edu", uid: 4 },
    { first_name: "Nandinii", last_name: "Yeleswarapu", email: "nandiniiys@tamu.edu", uid: 5 },
    { first_name: "Tejas", last_name: "Singhal", email: "singhalt@tamu.edu", uid: 6 },
    { first_name: "Ze", last_name: "Sheng", email: "zesheng@tamu.edu", uid: 7 }
  ]
  users.each do |user|
    new_user = User.find_or_create_by(user)
    Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
    Settings.find_or_create_by!(user_id: new_user.id, roles: [ "System Admin", "Member" ])
  end
end


file_path = Rails.root.join('db/wordle-words.txt')
words = File.readlines(file_path).map { |word| word.chomp }
today = Date.today

30.times do |i|
  word_index = rand(0..words.length)
  Wordle.create!(play_date: today + i, word: words[word_index])
  words.delete_at(word_index)
end
