Given('I am on the landing page') do
  visit games_path
end

Then('I should see a list of games') do
  expect(page).to have_css('.game-list')
end