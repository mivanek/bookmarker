require 'spec_helper'

describe BookmarksController do

  let(:bookmark){ mock_model(Bookmark).as_null_object }
  subject { page }

  describe "#index" do
    before do
      Bookmark.should_receive(:all).and_return(bookmark)
      get :index 
    end

    it { assigns(:bookmarks).should_not be_nil }
  end

  describe "#new" do
    before do
      Bookmark.should_receive(:new).and_return(bookmark)
      get :new
    end
    it { should render_template('new') }
    it { assigns(:bookmark).should_not be_nil }
  end
end
