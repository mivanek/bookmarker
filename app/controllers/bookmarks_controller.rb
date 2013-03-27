require 'parser'

class BookmarksController < ApplicationController
  include ElementsParser

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
    bookmark = Bookmark.find(params[:id])
    success = bookmark.destroy
    @bookmarks = Bookmark.all
    respond_to do |format|
      if success
        format.html { redirect_to bookmarks_path, success: "Bookmark deleted successfully." }
        format.js { @bookmarks }
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
