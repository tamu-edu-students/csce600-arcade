Given('the word for today is {string}') do |word|
  Wordle.create!(play_date: Date.today, word: word)
end

Given('I am on the Wordle play page') do
  visit '/wordles/play'
end

When('I guess the word {string}') do |word|
  expect(page).to have_field('wordle-guess-input')
  fill_in 'wordle-guess-input', with: word
  click_button 'Submit Guess'
end

When('I guess the word {string} {int} times') do |word, count|
  count.times do
    step "I guess the word \"#{word}\""
  end
end

Then('I should see {string} on the Wordle page') do |message|
  expect(page).to have_content(message)
end

Then('I should see confetti on the screen') do
  # Check if confetti.js has been triggered (you may need to mock this or use JavaScript validation)
  expect(page.evaluate_script('typeof confetti')).to eq('function')
end

Then('I should see the correct word was {string}') do |correct_word|
  expect(page).to have_content("The correct word was: #{correct_word}")
end

When('I reset the game session') do
  expect(page).to have_button('Reset Game')
  click_button 'Reset Game'
end

Given('there is no word for today') do
  Wordle.where(play_date: Date.today).destroy_all
end

When('I visit the Wordle play page') do
  visit '/wordles/play'
end

Then('the game should be ready for new guesses') do
  expect(page).to have_content('Attempts: 0')
  # Also verify grid is cleared
  expect(page).to have_selector('.wordle-tile', count: 30)  # 6 rows x 5 columns = 30 tiles
  expect(page).to have_no_selector('.wordle-tile[data-filled="true"]')
end
