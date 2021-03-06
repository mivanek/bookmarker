include ApplicationHelper

def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in(user)
  visit signin_path
  fill_in "E-mail", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def persisted_sign_in(user)
  visit signin_path
  fill_in "E-mail", with: user.email
  fill_in "Password", with: user.password
  check 'persisted_login'
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end
