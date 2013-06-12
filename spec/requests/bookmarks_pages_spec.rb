require 'spec_helper'

describe "Bookmarks" do
  let(:user){ FactoryGirl.create(:user_with_bookmarks) }
  let(:bookmark){ FactoryGirl.create(:bookmark, user_id: user.id) }
  let!(:folder){ FactoryGirl.create(:folder, user_id: user.id) }

  describe "destroy action" do
    before do
      sign_in user
      visit bookmarks_path
    end

    it { page.should have_link('Delete', href: bookmark_path(Bookmark.first)) }
    it "should be able do delete a bookmark" do
      expect { page.click_link('Delete', href: bookmark_path(Bookmark.first)) }.
        to change(Bookmark, :count).by(-1)
    end
  end
end
