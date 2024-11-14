Given('I am logged into Arcade') do
    visit '/auth/google_oauth2/callback'
end

When('I select {string} from the dropdown') do |option|
    find('#myacc').click
    find('.dropdown-content-account a', text: option).click
end
