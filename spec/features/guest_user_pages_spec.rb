require 'spec_helper'

describe 'guest user' do
  subject { page }

  describe 'on the root path' do
    before { visit root_path }
    it { should have_link 'Demo' }
    it { should have_link 'Sign in' }

    describe 'when I click demo' do
      before { click_link 'Demo' }

      it { should have_selector('h1', text: 'Your Bookmarks') }
      it { should have_link('Sign in') }

      describe "and I click create an account" do
        before { click_link 'Create an account' }

        it { should have_selector('h1', text: 'Sign up') }
        it { should_not have_selector('h1', text: 'Your Bookmarks') }
      end
      describe "and I click on the logo" do
        before { click_link "bookmarks application" }

        it { should have_selector('h1', 'Bookmarks Application') }
        it { should have_link('Sign in') }
      end
    end
  end
end
