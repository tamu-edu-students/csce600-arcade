Given('I am logged into Arcade') do
    visit(welcome_index_path)
    OmniAuth.config.test_mode = true
    click_button("Login with Google")
end

When('I select {string} from the dropdown') do |option|
    find('.dropbtn').click
    find('.dropdown-content a', text: option).click
end