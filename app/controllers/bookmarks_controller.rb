require 'parser'

class BookmarksController < ApplicationController
  before_filter :signed_in_user

  def index
    @bookmarks = current_user.bookmarks
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    respond_to do |format|
      format.js do
        create_remote(params[:link]) and return
      end
      format.html do
        @bookmark = current_user.bookmarks.build(params[:bookmark])
        if @bookmark.save
          flash[:success] = "Bookmark successfully created."
          redirect_to bookmarks_path
        else
          render 'new'
        end
      end
    end
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    respond_to do |format|
      if bookmark.destroy
        format.html { redirect_to bookmarks_path,
                      success: "Bookmark deleted successfully." }
        format.js do
          @bookmarks = current_user.bookmarks
        end
      else
        format.html do
          flash[:error] = "Failed to delete bookmark."
          redirect_to bookmarks_path and return
        end
        format.js
      end
    end
  end

  def update
    bookmark = Bookmark.find(params[:id])
    if bookmark.update_attributes(params[:bookmark])
      respond_to do |format|
        format.js { @bookmarks = current_user.bookmarks }
        format.html do
          flash[:success] = "Bookmark successfully updated."
          redirect_to bookmarks_path
        end
      end
    end
  end

  def edit
    @bookmark = Bookmark.find(params[:id])
    respond_to do |format|
      format.js { @bookmark }
      format.html { @bookmark }
    end
  end

  def create_remote(link)
    title, description, url = parser.new(link).parse
    bookmark = current_user.bookmarks.build(title: title, description: description, url: url)
    respond_to do |format|
      # TODO implementiraj provjeru url-a
      if bookmark.save
        format.js { @bookmarks = current_user.bookmarks and return}
      else
        format.js
      end
    end
  end

  def reorder
    @bookmark_ids = params[:bookmarks]
    n = 0
    ActiveRecord::Base.transaction do
      @bookmark_ids.each do |id|
        category = Bookmark.find(id)
        category.sequence = n
        n += 1
        category.save
      end
    end
    render :json => {}
  end

  private 

    def parser
      ElementsParser
    end
end
