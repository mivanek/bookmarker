require 'spec_helper'

describe "FolderPages" do

  subject { page }

  describe "new folder page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:folder) { FactoryGirl.create(:folder, user_id: user.id) }

    before(:each) do
      sign_in user
      visit root_path
    end

    describe "with valid data", :js => true do
      before do
        click_link "Create new folder"
        fill_in "Folder name", with: "New folder"
        click_button "Create folder"
      end

      it { should have_selector('tr', text: "New folder") }
    end
  end

  #describe "delete folder", :js => true do
    #let!(:user) { FactoryGirl.create(:user_with_bookmarks) }
    #let!(:folder) { user.folders.where('name = ?', 'Videos').first }
    #let!(:bookmark) { folder.bookmarks.first }

    #before do
      #sign_in user
      #visit folders_path
    #end

    #it "also delete bookmarks" do
      #click_link('Delete', href: delete_form_folders_path(id: folder.id))
      #expect { click_link "Yes" }.to change(Folder, :count).by(-1)
    #end
  #end
end
