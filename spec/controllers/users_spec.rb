require 'spec_helper'

describe UsersController do

  let(:user) { mock_model(User).as_null_object }
  let(:user_2) { User.new(name: "test", email: "test@test.com", password: "foobar",
                          password_confirmation: "foobar", demo: true) }

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
      it { flash[:success].should == "Welcome to Bookmarks Application." }
    end

    context "failed to create user" do
      before do
        user.should_receive(:save).and_return(false)
        post :create
      end

      it { response.should render_template('new') }
      it { flash[:error].should == "Failed to create user, please try again." }
    end

    context "when loged in, redirect to bookmarks path" do
      before do
        @controller.stub(:signed_in?).and_return(true)
        post :create
      end

      it { response.should redirect_to(bookmarks_path) }
    end
  end

  describe "#update" do
    before do
      @controller.stub(:correct_user).and_return(:true)
      @controller.stub(:signed_in_user).and_return(:true)
      @user = user_2.save
      @controller.instance_variable_set(:@user, @user)
      put :update, id: @user.id, user: { name: "test_user_2" }
    end

    it { flash[:success].should == "Account successfully turned permanent." }
    it { response.should redirect_to(root_path) }
  end
end
