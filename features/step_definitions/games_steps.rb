Given('I am on the landing page') do
  visit games_path
end

Then('I should see a list of games') do
  expect(page).to have_css('.game-list')
end


When('I click the Play button for {string}') do |game_name|
  within(:xpath, "//div[h3[text()='#{game_name}']]") do
    click_button 'Play'
  end
end
