FactoryGirl.define do
  factory :bookmark do
    title "reddit.com"
    url "http://www.reddit.com"
    description "The frontpage of the Internet."
  end

  factory :user do
    name "test user"
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :folder do
    name "no_folder"
    add_attribute :sequence, 1

    factory :non_blank_folder do
      name "Test folder"
    end
  end
end
