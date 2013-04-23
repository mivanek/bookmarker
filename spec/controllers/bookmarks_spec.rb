require 'spec_helper'

describe BookmarksController do

  let(:bookmark){ mock_model(Bookmark).as_null_object }
  let(:user) { FactoryGirl.create(:user) }
  let!(:r_bookmark) { FactoryGirl.create(:bookmark, user_id: user.id) }
  #let(:user) { User.find(r_bookmark.user_id) }
  #subject { page }
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
    before(:each){ @controller.stub(:current_user).and_return(user) }

    describe "HTML create" do
      before do
        post :create, bookmark: r_bookmark.attributes.except("id", "created_at", "updated_at")
      end

      it { flash[:success].should == "Bookmark successfully created." }
      it { should redirect_to bookmarks_path }
    end

    describe "AJAX create" do
      it "should increase the bookmark count" do
        expect do
          xhr :post, :create, link: "http://www.index.hr"
        end.to change(Bookmark, :count).by(1)
      end
    end
  end

  describe "#destroy" do
    describe "deletion with Ajax" do
      before(:each){ @controller.stub(:current_user).and_return(user) }

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

    describe "HTML delete" do
      before{ @controller.stub(:current_user).and_return(user) }

      it "should decrease the bookmarks count" do
        expect do
          delete :destroy, id: r_bookmark.id
        end.to change(Bookmark, :count).by(-1)
      end

      context "should set the flash" do
        before{ delete :destroy, id: r_bookmark.id }
        it { flash[:success].should == "Bookmark deleted successfully." }
        it { should redirect_to bookmarks_path }
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
