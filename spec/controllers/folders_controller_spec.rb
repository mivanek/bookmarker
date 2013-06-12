require 'spec_helper'

describe FoldersController do

  let(:user) { FactoryGirl.create(:user) }
  let!(:folder) { FactoryGirl.create(:folder, user_id: user.id, sequence: 1) }
  let!(:bookmark) { FactoryGirl.create(:bookmark, user_id: user.id,
                                       folder_id: folder.id, sequence: 1) }

  describe "#new" do
    before do
      Folder.should_receive(:new).and_return(folder)
      get :new
    end

    it { assigns(:folder).should_not be_nil }
  end

  describe "#create" do
    context "successfull HTML create" do
      before do
        @controller.stub(:current_user).and_return(user)
        @new_folder = { name: "New folder", user_id: user.id }
      end
      it "should create a folder" do
        expect { post :create, folder: @new_folder }.to change(Folder, :count).by(1)
      end

      it "should set the flash" do
        post :create, folder: @new_folder 
        flash[:success].should == "Folder successfully created."
      end

      it "should redirect to bookmarks path" do
        post :create, folder: @new_folder 
        page.should redirect_to bookmarks_path
      end
    end

    context "failed create" do
      before do
        @controller.stub(:current_user).and_return(user)
        Folder.stub(:save).and_return(false)
      end

      it "should not create a folder" do
        expect { post :create, folder: @new_folder }.not_to change(Folder, :count)
      end

      it "should redirect to new" do
        post :create, folder: @new_folder 
        page.should render_template(:new)
      end
    end
  end

  describe "#destroy" do
    before do
      Folder.should_receive(:find).and_return(folder)
      @controller.stub(:current_user).and_return(user)
    end

    context "when i click to destroy bookmarks" do
      it "should destroy the folder" do
        expect do
          xhr :delete, :destroy, id: folder.id, delete_bookmarks: "true"
        end.to change(Folder, :count).by(-1)
      end

      it "should destroy bookmarks" do
        expect do
          xhr :delete, :destroy, id: folder.id, delete_bookmarks: "true"
        end.to change(Bookmark, :count).by(-1)
      end
    end

    context "when i click NOT to destroy bookmarks" do

      it "should destroy the folder" do
        expect do
          xhr :delete, :destroy, id: folder.id, delete_bookmarks: "false"
        end.to change(Folder, :count).by(-1)
      end

      it "should NOT destroy the bookmarks" do
        expect do
          xhr :delete, :destroy, id: folder.id, delete_bookmarks: "false"
        end.not_to change(Bookmark, :count)
      end
    end
  end

  describe "#update" do
    before do
      folder.name = "New folder"
      @controller.stub(:current_user).and_return(user)
      xhr :put, :update, id: folder.id,
        folder: folder.attributes.except("id", "updated_at", "created_at")
    end

    it { folder.reload.name.should == "New folder" }
  end

  describe "#edit" do
    before do
      get :edit, id: folder.id
    end

    it { assigns(:folder).should == folder }
  end

  describe "#index" do
    before do
      @controller.stub(:current_user).and_return(user)
      get :index
    end

    it { assigns(:folders).should_not be_empty }
  end

  describe "#delete form" do
    it do
      xhr :get, :delete_form, id: folder.id
      assigns(:folder).should_not be_nil
    end
  end
end
