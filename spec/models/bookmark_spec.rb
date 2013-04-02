require 'spec_helper'

describe Bookmark do
  before do
    @bookmark = Bookmark.new(title: "bookmark.com", description: "A test bookmark",
                             url: "http://www.bookmark.com")
  end

  subject { @bookmark }

  it { should respond_to(:title) }
  it { should respond_to(:url) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }

  it { should be_valid }

  it "the title should not be empty" do
    [""," ",nil].each do |title|
      @bookmark.title = title
      should_not be_valid
    end
  end

  describe "the description should not be empty" do
    before { @bookmark.description = " " }
    it { should_not be_valid }
  end

  describe "with invalid url" do
    it do
      urls = %w(onion://www.bookmark.com git://www.bookmark.com test://www.bookmark.com)
      urls.each do |url|
        @bookmark.url = url
        should_not be_valid
      end
    end
  end

  describe "with valid url" do
    it do
      urls = %w(http://www.bookmark.com HTtp://www.bookmark.com https://www.bookmark.com)
      urls.each do |url|
        @bookmark.url = url
        should be_valid
      end
    end
  end
end
