FactoryGirl.define do
  factory :bookmark do
    title "reddit.com"
    url "http://www.reddit.com"
    description "The frontpage of the Internet."
    user_id 1
  end

  factory :user do
    name "test user"
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
