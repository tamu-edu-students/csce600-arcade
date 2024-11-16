## add initial games to the database
initial_games = [
    { name: 'Spelling Bee', game_path: 'bees_play_path', image_url: 'https://www.pngkey.com/png/full/431-4311161_spelling-bee-spelling-bee-logo.png' },
    { name: 'Wordle', game_path: 'wordles_play_path', image_url: 'https://brandmentions.com/wiki/images/c/cd/Wordle_logo.png' },
    { name: 'Letter Boxed', game_path: 'boxes_play_path', image_url: 'https://calebrob.com/assets/images/letter_boxed.png' },
    { name: '2048', game_path: 'game_2048_play_path', image_url: 'https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/6a/d4/1c/6ad41c3a-eb36-329f-513e-08e3912681f8/AppIcon-0-0-1x_U007emarketing-0-4-85-220.png/512x512bb.jpg' }
]

initial_games.each do |game|
  temp_game = Game.find_or_create_by(name: game[:name])

  temp_game.update(game_path: game[:game_path], image_url: game[:image_url])
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
  test_user = { first_name: 'Test', last_name: 'User', email: 'test_email@tamu.edu' }
  new_user = User.find_or_create_by(test_user)
  Role.find_or_create_by!(user_id: new_user.id, role: "System Admin")
  Role.find_or_create_by!(user_id: new_user.id, role: "Puzzle Setter", game_id: Game.find_by(name: "Wordle").id)
  Settings.find_or_create_by!(user_id: new_user.id) do |settings|
    settings.active_roles = 'System Admin,Puzzle Setter-Wordle'
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
  if WordleDictionary.all.empty?
    file_path_solns = Rails.root.join('db/wordle-words.txt')
    File.readlines(file_path_solns).each do | word |
      WordleDictionary.create!(word: word.chomp, is_valid_solution: true)
    end

    file_path_guesses = Rails.root.join('db/valid_guesses.txt')
    File.readlines(file_path_guesses).each do | word |
      WordleDictionary.create!(word: word.chomp, is_valid_solution: false)
    end
  end

  if WordleDictionaryBackup.all.empty?
    file_path_solns = Rails.root.join('db/wordle-words.txt')
    File.readlines(file_path_solns).each do | word |
      WordleDictionaryBackup.create!(word: word.chomp, is_valid_solution: true)
    end

    file_path_guesses = Rails.root.join('db/valid_guesses.txt')
    File.readlines(file_path_guesses).each do | word |
      WordleDictionaryBackup.create!(word: word.chomp, is_valid_solution: false)
    end
  end

  if Wordle.where(play_date: Date.today).empty?
    word = WordleDictionary.where(is_valid_solution: true).sample.word
    todays_wordle = Wordle.new(play_date: Date.today, word: word)
    todays_wordle.skip_today_validation = true
    todays_wordle.save
  end
else
  WordleDictionary.create(word: 'floop', is_valid_solution: true)
  WordleDictionary.create(word: 'apple', is_valid_solution: true)
  WordleDictionary.create(word: 'ploof', is_valid_solution: false)
  if Wordle.where(play_date: Date.today).empty?
    todays_wordle = Wordle.new(play_date: Date.today, word: "floop")
    todays_wordle.skip_today_validation = true
    todays_wordle.save
  end
  if Wordle.where(play_date: Date.yesterday).empty?
    yesterday_wordle = Wordle.new(play_date: Date.yesterday, word: "apple")
    yesterday_wordle.skip_today_validation = true
    yesterday_wordle.save
  end
end

Bee.create(letters: "ARCHIUT", play_date: Date.today, ranks: [ 5, 10, 20, 40 ])
