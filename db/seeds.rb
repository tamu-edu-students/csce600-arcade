## add initial games to the database
initial_games = [
    { name: 'Spelling Bee', game_path: 'bees_play_path' },
    { name: 'Wordle', game_path: 'wordles_play_path' },
    { name: 'Letter Boxed', game_path: 'letterboxed_path' },
    { name: '2048', game_path: 'game_2048_play_path' }
]

initial_games.each do |game|
  temp_game = Game.find_or_create_by(name: game[:name])

  temp_game.update(game_path: game[:game_path])
end

Game.find_or_create_by(id: -1, name: 'Dummy Game', game_path: 'welcome')

## adding initial aesthetics to the databse
initial_aesthetics = [
  {
    game_id: Game.find_by(name: "Spelling Bee").id,
    labels: [
      "Center Letter",
      "Submit Button",
      "Submit Button Hover",
      "Font"
    ],
    colors: [
      '#FFFF00',
      '#0000FF',
      '#cb7af0',
      '#000000'
    ],
    font: 'Verdana, sans-serif'
  },
  {
    game_id: Game.find_by(name: "Wordle").id,
    labels: [
      "Correct Letter & Position",
      "Correct Letter",
      "Incorrect Letter",
      "Default",
      "Font"
    ],
    colors: [
      '#5aab4f',
      '#f2d750',
      '#d25151',
      '#70a6bd',
      '#000000'
    ],
    font: 'Verdana, sans-serif'
  },
  {
    game_id: Game.find_by(name: "Letter Boxed").id,
    labels: [
      "Box Color",
      "Line Color",
      "Unused Letter",
      "Used Letter",
      "Font"
    ],
    colors: [
      '#FFFFFF',
      '#FF4F4B',
      '#FFFFFF',
      '#FFCCCB',
      '#000000'
    ],
    font: 'Verdana, sans-serif'
  },
  {
    game_id: Game.find_by(name: "2048").id,
    labels: [
      "Background",
      "Grid",
      "Font"
    ],
    colors: [
      '#faf8ef',
      '#bbada0',
      '#776e65'
    ],
    font: 'Arial, sans-serif'
  }
]

initial_aesthetics.each do |aesthetic|
  temp_aesthetic = Aesthetic.find_or_create_by(game_id: aesthetic[:game_id])

  temp_aesthetic.update(
    labels: aesthetic[:labels],
    colors: aesthetic[:colors],
    font: aesthetic[:font]
  )
end

Aesthetic.find_or_create_by(
  id: -1,
  game_id: Game.find_by(name: "Dummy Game").id,
  labels: [ "Font" ],
  colors: [ '#000000' ],
  font: 'Verdana, sans-serif'
)

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
    Role.find_or_create_by(user_id: new_user.id, role: "System Admin")
    Role.find_or_create_by(user_id: new_user.id, role: "Member")
    Settings.find_or_create_by(user_id: new_user.id) do |settings|
      settings.active_roles = 'System Admin'
    end
  end
end

if !Rails.env.test?
  if WordleValidSolution.all.empty?
    file_path = Rails.root.join('db/wordle-words.txt')
    File.readlines(file_path).each do | word |
      WordleValidSolution.create!(word: word.chomp)
    end
  end

  if WordleValidGuess.all.empty?
    file_path = Rails.root.join('db/valid_guesses.txt')
    File.readlines(file_path).each do | word |
      WordleValidGuess.create!(word: word.chomp)
    end
  end

  if Wordle.where(play_date: Date.today).empty?
    Wordle.create!(play_date: Date.today, word: WordleValidSolution.all.sample.word)
  end
else
  WordleValidSolution.create(word: 'floop')
  WordleValidGuess.create(word: 'ploof')
  if Wordle.where(play_date: Date.today).empty?
    Wordle.create!(play_date: Date.today, word: 'floop')
  end
end



Bee.create(letters: "ARCHIUT", play_date: Date.today)
