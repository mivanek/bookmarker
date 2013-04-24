require 'spec_helper'

describe "Authentication", :type => :feature do
  subject { page }

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:folder) { FactoryGirl.create(:folder, user_id: user.id) }
      before { click_button "Sign in" }

      it { should have_selector('h1', text: 'Sign in') }
      it { should have_error_message('Invalid') }
      it { should_not have_link('Sign out', href: signout_path) }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error', text: "Invalid") }
      end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:folder) { FactoryGirl.create(:folder, user_id: user.id) }
      before { sign_in user }

      it { should have_selector('h1', text: 'Your Bookmarks') }
      it { should have_link('Sign out', href: signout_path) }

      describe "visiting the new page" do
        before { visit signup_path }
        it { should_not have_selector('h1', text: 'Sign up') }
        it { should have_selector('h1', text: 'Your Bookmarks') }
      end

      describe "submitting to the create action" do
        before { post users_path }
        it { should have_selector('h1', text: "Your Bookmarks") }
      end

      describe "sign out" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: 'Sign in') }
          it { should have_selector('div.alert.alert-notice', text: "Please sign in.") }
        end

        describe "submitting the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the bookmarks controller" do
        before { visit bookmarks_path }
        it { current_path.should == signin_path }
      end
    end
  end
end
