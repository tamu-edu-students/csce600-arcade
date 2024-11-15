Given('I am on the login page') do
    visit(welcome_path)
end

Then('I should see {string}') do |string|
    expect(page).to have_content(string)
end

When('I press {string}') do |string|
    first('button[title="' + string + '"]').click
end

Then('I should not see {string}') do |string|
    expect(page).not_to have_content(string)
end

When('I login as System Admin') do
    OmniAuth.config.test_mode = true
    click_button("Login with Google")
end

When('I go to the landing page') do
    visit(games_path)
end

Then('I should be redirected to the game page for {string}') do |game_name|
    game = Game.find_by(name: game_name)
    expect(page).to have_current_path(game_path(game))
end
