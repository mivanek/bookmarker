require 'spec_helper'

describe BookmarksController do

  let(:bookmark){ mock_model(Bookmark).as_null_object }
  let(:user) { FactoryGirl.create(:user) }
  let(:r_bookmark) { FactoryGirl.create(:bookmark, user_id: user.id) }
  subject { page }
  before { @controller.stub(:signed_in_user).and_return(true) }

  describe "#index" do
    before do
      @controller.stub(:current_user).and_return(user)
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

  describe "#create" do
    before do
      @controller.stub(:current_user).and_return(user)
      post :create, bookmark: r_bookmark.attributes.except("id", "created_at", "updated_at")
    end

    it { flash[:success].should == "Bookmark successfully created." }
    it { should redirect_to bookmarks_path }
  end

  describe "#destroy" do
    describe "deletion with Ajax" do
      it "should decrease the Bookmarks count" do
        expect do
        xhr :delete, :destroy, id: r_bookmark.id
        end.to change(Bookmark, :count).by(1)
      end

      it "should respond with success" do
        xhr :delete, :destroy, id: r_bookmark.id
        response.should be_success
      end
    end
  end

  describe "#edit" do
    before do
      Bookmark.should_receive(:find).and_return(bookmark)
      put :edit, id: bookmark.id
    end

    it { assigns(:bookmark).should == bookmark }
  end
end
