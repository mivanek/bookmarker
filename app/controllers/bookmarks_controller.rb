require 'parser'

class BookmarksController < ApplicationController
  before_filter :signed_in_user

  def index
    @folders = current_user.folders
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
        bookmark = current_user.bookmarks.build(params[:bookmark])
        binding.pry
        if bookmark.save
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
    bookmark.destroy
    respond_to do |format|
      format.html do
        flash[:success] = "Bookmark deleted successfully."
        redirect_to bookmarks_path
      end
      format.js do
        @folders = current_user.folders
        @bookmarks = current_user.bookmarks
      end
    end
  end

  def update
    bookmark = Bookmark.find(params[:id])
    if bookmark.update_attributes(params[:bookmark])
      respond_to do |format|
        format.js do
          @bookmarks = current_user.bookmarks
          @folders = current_user.folders
        end
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


  def reorder
    no_folder = current_user.folders.where("name = ?", "no_folder").first.id
    @element_ids = params[:element_ids].dup
    @element_ids = @element_ids.split("&")
    n = 1
    @element_ids.each do |id|
      split_id = id.split("[]=")
      if split_id[0] == "folder"
        @folder_id = split_id[1]
        folder = Folder.find(@folder_id)
        folder.update_attributes(sequence: n)
      elsif split_id[0] == "foldered-bookmark"
        bookmark = Bookmark.find(split_id[1])
        bookmark.update_attributes(sequence: n, folder_id: @folder_id)
      elsif split_id[0] == "bookmark"
        bookmark = Bookmark.find(split_id[1])
        bookmark.update_attributes(sequence: n, folder_id: no_folder)
      end
      n += 1
    end
    render :json => {}
  end

  private

    def create_remote(link)
      begin
        title, description, url = parser(link).parse
        bookmark = current_user.bookmarks.build(title: title, description: description, url: url)
        if bookmark.save
          @folders = current_user.folders
          @bookmarks = current_user.bookmarks
        end
      rescue
        flash.now[:error] = "Failed to parse website, please add bookmark manually."
      end
    end

    def parser(link)
      ElementsParser.new(link)
    end
end
