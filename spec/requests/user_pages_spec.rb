require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user_with_bookmarks) }
    let!(:folder){ FactoryGirl.create(:folder, user_id: user.id) }

    before(:each) do
      sign_in user
      visit root_path
    end

    it { should have_selector('h1', text: "Your Bookmarks") }

    describe "bookmarks" do
      it { should have_selector('#bookmarks_table')}

      it { should have_selector('tr', text: /google/i) }
      it { should have_selector('tr', text: /facebook/i) }
      it { should have_selector('tr', text: /youtube/i) }
      it { should have_selector('tr', text: /facebook/i) }
      it { should have_selector('tr', text: /amazon/i) }
    end
  end

  describe "edit user page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:folder) { FactoryGirl.create(:folder, user_id: user.id) }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    it { should have_selector('h3', text: "Change user settings") }

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid infromation" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
