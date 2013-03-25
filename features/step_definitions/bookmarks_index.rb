Given /^I am on the bookmarks index page$/ do
  visit root_path
end

Then /^I should see the "(.*)" title$/ do |title|
  page.should have_title(title)
end
