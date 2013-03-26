class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.all
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    if Bookmark.create(params[:bookmark])
      flash[:success] = "Bookmark successfully created"
      redirect_to 'index'
    else
      flash[:error] = "Failed to create bookmark"
      redirect_to 'index' and return
    end
  end

  def destroy
    if Bookmark.find(params[:id]).destroy
      flash[:notice] = "Bookmark deleted successfully."
      redirect_to 'index'
    else
      flash[:error] = "Failed to delete bookmark."
      redirect_to 'index' and return
    end
  end

  def edit
    @bookmark = Bookmark.find(params[:id])
  end
end
