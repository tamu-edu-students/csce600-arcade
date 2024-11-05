Then('I enter {string} into the {string} field') do |input_text, field_id|
    fill_in(field_id, with: input_text)
end

When('I click the submit button') do
    find('#sbsubmit').click
end
