class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.all
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    respond_to do |format|
      if Bookmark.create(params[:bookmark])
        format.html do
          flash[:success] = "Bookmark successfully created"
          redirect_to bookmarks_path
        end
        format.js
      else
        format.html do
          flash[:error] = "Failed to create bookmark"
          redirect_to bookmarks_path and return
        end
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if Bookmark.find(params[:id]).destroy
        format.html do
          flash[:notice] = "Bookmark deleted successfully."
          redirect_to bookmarks_path
        end
        format.js { @bookmarks = Bookmark.all }
      else
        format.html do
          flash[:error] = "Failed to delete bookmark."
          redirect_to bookmarks_path and return
        end
        format.js
      end
    end
  end

  def edit
    @bookmark = Bookmark.find(params[:id])
  end
end
