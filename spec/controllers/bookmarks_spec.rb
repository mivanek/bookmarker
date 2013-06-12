require 'spec_helper'

describe BookmarksController do

  let(:bookmark){ mock_model(Bookmark, title: "Test title", description: "test",
                            url: "http://www.test.com").as_null_object }
  let(:user) { FactoryGirl.create(:user) }
  let(:folder) { FactoryGirl.create(:folder, user_id: user.id) }
  let(:folder_2) { FactoryGirl.create(:folder, user_id: user.id,
                                      name: "A New folder") }
  let!(:bookmark_2) { FactoryGirl.create(:bookmark, title: "new bookmark",
                                         description: "a new bookmark",
                                         url: "http://www.new.com",
                                         user_id: user.id) }
  let!(:r_bookmark) { FactoryGirl.create(:bookmark, user_id: user.id) }
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
      context "successfull create" do
        before do
          post :create, bookmark: r_bookmark.attributes.except("id", "created_at", "updated_at")
        end

        it { flash[:success].should == "Bookmark successfully created." }
        it { should redirect_to bookmarks_path }
      end

      context "failed create" do
        before do
          Bookmark.any_instance.stub(:save).and_return(false)
          post :create, bookmark: r_bookmark.attributes.except("id", "created_at", "updated_at")
        end

        it { should render_template 'new' }
      end
    end


    describe "AJAX create" do
      context "with a valid link" do
        it "should increase the bookmark count" do
          expect do
            xhr :post, :create, link: "http://www.index.hr"
          end.to change(Bookmark, :count).by(1)
        end
      end

      context "witn an invalid linK" do
        it "should NOT increase the bookmark count" do
          expect do
            xhr :post, :create, link: "http://www.bullshitlink.com"
          end.not_to change(Bookmark, :count)
        end

        it "should set a flash" do
          xhr :post, :create, link: "http://www.bullshitlink.com"
          flash[:error].should == "Failed to parse website, please add bookmark manually."
        end

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
      get :edit, id: bookmark.id
    end

    it { assigns(:bookmark).should == bookmark }
  end

  describe "#update" do

    before { @controller.stub(:current_user).and_return(user) }

    describe "AJAX update" do
      before do
        @bookmark = r_bookmark
        @bookmark.save
        @bookmark.title = "updated name"
        xhr :put, :update, id: @bookmark.id,
          bookmark: @bookmark.attributes.except("id", "updated_at", "created_at")
      end

      it { @bookmark.reload.title.should == "updated name" }
    end

    describe "HTML update" do
      before do
        Bookmark.should_receive(:find).and_return(r_bookmark)
        put :update, id: r_bookmark.id,
          bookmark: r_bookmark.attributes.except("id", "updated_at", "created_at")
      end

      it { flash[:success].should == "Bookmark successfully updated." }
      it { should redirect_to bookmarks_path }
    end
  end

  describe "#reorder" do
    before do
      @element_ids = "folder[]=#{folder.id}&folder[]=#{folder_2.id}&bookmark[]=#{bookmark_2.id}&foldered-bookmark[]=#{r_bookmark.id}"
      @controller.stub(:current_user).and_return(user)
      @closed_folders = "folder-#{folder_2.id}"
      xhr :post, :reorder, element_ids: @element_ids,
                           closed_folders: @closed_folders
    end

    it { assigns(:element_ids).should_not be_nil }
  end

  describe "#close_or_open_folder" do
    before do
      @folder = []
      @folder << folder.id
    end

    context "the folder is closed" do
      before do
        @folder << "closed"
        xhr :post, :close_or_open_folder, opened_or_closed: @folder
      end

      it { assigns(:folder_id).should_not be_nil }
    end

    context "the folder is closed" do
      before do
        @folder << "opened"
        xhr :post, :close_or_open_folder, opened_or_closed: @folder
      end

      it { assigns(:folder_id).should_not be_nil }
    end
  end
end
