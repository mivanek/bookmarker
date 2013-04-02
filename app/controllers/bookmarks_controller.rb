require 'parser'

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
          flash[:success] = "Bookmark successfully created."
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
    respond_to do |format|
      if bookmark.destroy
        format.html { redirect_to bookmarks_path,
                      success: "Bookmark deleted successfully." }
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

  def create_remote
    title, description, url = parser.new(params[:link]).parse
    respond_to do |format|
      # TODO implementiraj provjeru url-a
      if Bookmark.create(title: title, description: description, url: url)
        format.js { @bookmarks = Bookmark.all }
      else
        format.js
      end
    end
  end

  private 

    def parser
      ElementsParser
    end
end
