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
end
