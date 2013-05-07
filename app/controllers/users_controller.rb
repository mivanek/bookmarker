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
      flash[:error] = "Failed to create user, please try again."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user, false
      flash[:success] = "Profile updated."
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
