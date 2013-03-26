require 'spec_helper'

describe BookmarksController do

  let(:r_bookmark) { FactoryGirl.create(:bookmark) }
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

  describe "#delete" do
    describe "deletion with Ajax" do
      it "should decrease the Bookmarks count" do
        expect do
        xhr :delete, :destroy, id: r_bookmark.id
        end.to change(Bookmark, :count).by(-1)
      end

      it "should respond with success" do
        xhr :delete, :destroy, id: r_bookmark.id
        response.should be_success
      end
    end
  end
end
