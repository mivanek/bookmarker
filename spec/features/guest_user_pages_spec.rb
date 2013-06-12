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
      it { should have_link('Make this account permanent') }

      describe "and I click create an account" do
        before { click_link 'Make this account permanent' }

        it { should have_selector('h1', text: 'Sign in') }
        it { should_not have_selector('h1', text: 'Your Bookmarks') }
      end
      describe "and I click on the logo" do
        before { click_link "bookmarker beta" }

        it { should have_selector('h1', 'Bookmarks Application') }
        it { should have_link('Make this account permanent') }
      end
    end
  end
end
