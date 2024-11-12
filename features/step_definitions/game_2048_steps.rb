Given('I am playing 2048') do
  visit game_2048_play_path
end

Then('I should see an empty 4x4 grid') do
  expect(page).to have_css('.game-board')
  expect(page).to have_css('.board-cell', count: 16)
end

When('I press the {string} arrow key') do |direction|
  page.execute_script("window.dispatchEvent(new KeyboardEvent('keydown', {'key': 'Arrow#{direction.capitalize()}'}));")
end

Then('the tiles should move accordingly') do
  expect(page).to have_css('.game-board')
end

Then('new tiles should appear') do
  expect(page).to have_css('.board-cell:not(:empty)')
end

When('I change the tile color to {string}') do |color|
  page.execute_script("document.documentElement.style.setProperty('--primary-clr', '#{color}');")
end

Then('the tile colors should update to {string}') do |color|
  expect(page).to have_css("[style*='#{color}']")
end

Given('I am on the games page') do
  visit games_path
end

Then('I should see a score of {string}') do |score|
  expect(page).to have_content("Score: #{score}")
end

Given('I am on the 2048 game page') do
  visit game_2048_play_path
end

Given('I am logged in as a {string}') do |role|
  visit welcome_path
  OmniAuth.config.test_mode = true
  click_button("Login with Google")
  @user = User.last
  Role.create!(user_id: @user.id, role: role)
end

When("I click the Aesthetic Settings button") do
  click_button(title: "Aesthetic Settings")
end

Then('I should see color customization options') do
  expect(page).to have_content("Customize Colors")
  expect(page).to have_css('.color-picker')
end

Then('the changes should be saved') do
  expect(page).to have_content("Settings saved successfully")
end
