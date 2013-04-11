require 'parser'

class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user, false
      populate
      flash[:success] = "Welcome to Bookmarks Application"
      redirect_to bookmarks_path
    else
      render 'new'
    end
  end

  def update
  end

  private

  # PROVJERIT ZA BOLJI NACIN KREIRANJA ENTRY-A KOD KREIRANJA KORISNIKA!!!
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def populate
      default_websites.each do |website|
        title, description, url = parser.new(website).parse
        current_user.bookmarks.create(title: title, description: description,
                                     url: url)
      end
    end

    def default_websites
      %w(http://www.ebay.com http://www.amazon.com http://www.google.com
         http://www.wikipedia.org http://www.facebook.com http://www.youtube.com)
    end

    def parser
      ElementsParser
    end
end
