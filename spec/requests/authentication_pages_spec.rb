require 'spec_helper'

describe "Authentication", :type => :feature do
  subject { page }

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      let(:user) { FactoryGirl.create(:user) }
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
        specify { response.should redirect_to(bookmarks_path) }
        it { should have_selector('h1', text: "Your Bookmarks") }
      end
    end
  end
end
