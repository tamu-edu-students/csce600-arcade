When('I visit the dashboard page') do
    visit dashboard_path
  end
  
  Then('I should see the dashboard message {string}') do |message|
    expect(page).to have_content(message)
  end
  
  Then('I should see a list of games including {string}, {string}, and {string}') do |game1, game2, game3|
    expect(page).to have_content(game1)
    expect(page).to have_content(game2)
    expect(page).to have_content(game3)
  end
  
  # New steps for guest user scenario
  
  Given('I am a guest user') do
    # Simulating the user as a guest by visiting the guest path which sets session[:guest]
    visit guest_path  # This path should be the one that sets session[:guest] to true
  end
  
  When('I try to visit the dashboard page') do
    visit dashboard_path
  end
  
  Then('I should be redirected to {string}') do |message|
    # Check if the user is redirected to the welcome page and sees the expected message
    expect(page).to have_content(message)
  end
  