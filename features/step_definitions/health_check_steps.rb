Given(/I am on the health check page/) do 
    visit(rails_health_check_path)
end

Then('I should see a green blank page') do
    expect(page.body).to include('style="background-color: green"')
end