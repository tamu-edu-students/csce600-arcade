Then('I click the Puzzle Settings button') do
    find('[title="Puzzle Settings"]').click
end

Then('I click the {string} button') do |string|
    click_button(string)
end