require 'parser'
class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def new
    if signed_in?
      redirect_to bookmarks_path
    end
    @user = User.new
  end

  def create
    if signed_in?
      redirect_to bookmarks_path and return
    end
    @user = User.new(params[:user])
    if @user.save
      sign_in @user, false
      flash[:success] = "Welcome to Bookmarks Application."
      redirect_to bookmarks_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_user.demo
      params[:user][:demo] = false
      flash[:success] = "Account successfully turned permanent."
    end
    if @user.update_attributes(params[:user])
      sign_in @user, false
      flash[:success] ||= "Profile updated."
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def create_demo
    password = string_generator
    email = "#{string_generator}@demo-user.com"
    user_array = [name: "user-#{string_generator}",
                  email: email,
                  password: password,
                  password_confirmation: password,
                  demo: true]
    user = User.create(user_array).first
    sign_in user, true
    flash[:success] =
      "Welcome to the demo version of Bookmarks Application.<br>
      We have created a temporary demo account for you to use. If you want to continue
      using this account, click on the 'Make this account permanent' in the header
      and sign in with the following parameters: <br>
      <ul>
        <li>Email: #{email}
        <li>Password: #{password}
      </ul>
      After you sign in, you will be prompted to enter a new email, user name and password, after
      which your account should become permanent.<br>
      If this account is not made permanent in the next 24 hours, it will be deleted.<br>
      We hope you'll enjoy your experience. This message will not be shown on your next request.".html_safe
    redirect_to bookmarks_path
  end

  private

    def string_generator
      SecureRandom.urlsafe_base64(6)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
