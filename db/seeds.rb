## add initial games to the database
initial_games = [
    { name: 'Spelling Bee', game_path: 'bees_play_path' },
    { name: 'Wordle', game_path: 'wordles_play_path' },
    { name: 'Letter Boxed', game_path: 'letterboxed_path' }
]

initial_games.each do |game|
  unless Game.exists?(name: game[:name])
    Game.create!(game)
  end
end

initial_aesthetics = [
  { game_id: Game.find_by(name: "Spelling Bee").id, primary_clr: '#FFFF00', secondary_clr: '#0000FF', tertiary_clr: '', font_clr: '#000000', font: 'Verdana, sans-serif', primary_clr_label: 'Center Letter Color', secondary_clr_label: 'Submit Button Color', tertiary_clr_label: 'Submit Button Hover Color' },
  { game_id: Game.find_by(name: "Wordle").id, primary_clr: '#008000', secondary_clr: '#ebcc34', tertiary_clr: '#808080', font_clr: '#000000', font: 'Verdana, sans-serif', primary_clr_label: 'Correct Letter & Position', secondary_clr_label: 'Correct Letter', tertiary_clr_label: 'Incorrect Letter' }
]

Game.create(
  id: 69,
  name: 'Dummy Game',
  game_path: 'welcome#index'
)

initial_aesthetics.each do |aesthetic|
  aesthetic_record = Aesthetic.find_or_create_by!(game_id: aesthetic[:game_id])

  aesthetic_record.update!(
     primary_clr: aesthetic[:primary_clr] || aesthetic_record.primary_clr,
     secondary_clr: aesthetic[:secondary_clr] || aesthetic_record.secondary_clr,
     tertiary_clr: aesthetic[:tertiary_clr] || aesthetic_record.tertiary_clr,
     font_clr: aesthetic[:font_clr] || aesthetic_record.font_clr,
     font: aesthetic[:font] || aesthetic_record.font,
     primary_clr_label: aesthetic[:primary_clr_label] || aesthetic_record.primary_clr_label,
     secondary_clr_label: aesthetic[:secondary_clr_label] || aesthetic_record.secondary_clr_label,
     tertiary_clr_label: aesthetic[:tertiary_clr_label] || aesthetic_record.tertiary_clr_label)
end

Aesthetic.create(
  id: 69,
  primary_clr: "#000000",
  secondary_clr: "#000000",
  tertiary_clr: "#000000",
  font_clr: "#000000",
  font: "Verdana, sans-serif",
  primary_clr_label: "",
  secondary_clr_label: "",
  font_clr_label: "",
  tertiary_clr_label: "",
  game_id: 69
)


## add test users to the test database and all developers as system admins to the prod database
if Rails.env.test?
  test_user = { first_name: 'Spongebob', last_name: 'Squarepants', email: 'spongey@tamu.edu' }
  new_user = User.find_or_create_by(test_user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
  Settings.find_or_create_by!(user_id: new_user.id) do |settings|
    settings.active_roles = 'System Admin'
  end

  test_member_user = { first_name: 'Patrick', last_name: 'Star', email: 'starry@tamu.edu' }
  new_member_user = User.find_or_create_by(test_member_user)
  Role.find_or_create_by!(user_id: new_member_user.id, role: "Member")
  Settings.find_or_create_by!(user_id: new_member_user.id) do |settings|
    settings.active_roles = 'System Admin'
  end
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
    Role.find_or_create_by!(user_id: new_user.id, role: "Member")
    Settings.find_or_create_by!(user_id: new_user.id) do |settings|
      settings.active_roles = 'System Admin'
    end
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

Bee.create(letters: "ARCHIUT", play_date: Date.today)
