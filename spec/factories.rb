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

    after(:build) { |user| user.class.skip_callback(:create, :after,
                                                    :populate_with_default_bookmarks) }

    factory :user_with_bookmarks do
      after(:create) { |user| user.send(:populate_with_default_bookmarks) }
      after(:create) { |user| user.send(:create_default_folder) }
    end
  end

  factory :folder do
    name "no_folder"
    add_attribute :sequence, 1

    factory :non_blank_folder do
      name "Test folder"
    end
  end
end
