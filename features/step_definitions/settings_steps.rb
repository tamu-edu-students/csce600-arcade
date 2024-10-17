When('I set the contrast to {string}') do |value|
  fill_in 'contrastInput', with: value # 'Contrast' should be the label or ID for the input field
end

Then('the contrast value should be {string}') do |value|
  expect(find_field('contrastInput').value).to eq(value)
end

When('I close the settings') do
  find('span.close').click
end
