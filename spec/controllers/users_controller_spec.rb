require 'spec_helper'

describe UsersController do

  let(:user) { mock_model(User).as_null_object }

  before do
    User.stub(:new).and_return(user)
  end

  describe '#new' do
    before do
      User.should_receive(:new).and_return(user)
      get :new
    end
    it { assigns(:user).should == user }
    it { page.should render_template('new') }
  end

  describe "#create" do
    context "successfully create user" do
      before do
        User.should_receive(:new).and_return(user)
        post :create
      end

      it { assigns(:user).should == user }
      it { response.should redirect_to(bookmarks_path) }
      it { flash[:success].should == "Welcome to Bookmarks Application" }
    end

    context "failed to create user" do
      before do
        user.should_receive(:save).and_return(false)
        post :create
      end

      it { response.should render_template('new') }
      it { flash[:error].should == "Failed to create user, please try again." }
    end
  end

  describe "#edit" do
    before do
      User.should_receive(:find).and_return(user)
      put :edit
    end

    
  end
end
