class FoldersController < ApplicationController
  def new
    @folder = Folder.new
  end

  def create
    @folder = current_user.folders.build(params[:folder])
    if @folder.save
      respond_to do |format|
        format.html do
          flash[:success] = "Folder successfully created."
          redirect_to bookmarks_path and return
        end
        format.js do
          @bookmarks = current_user.bookmarks
          @folders = current_user.folders
        end
      end
    else
      render 'new' and return
    end
  end

  def destroy
    folder = Folder.find(params[:id])
    bookmarks = folder.bookmarks
    if params[:delete_bookmarks] == "true"
      bookmarks.destroy_all
    else
      no_folder = current_user.folders.where(name: 'no_folder').first
      bookmarks.each do |bookmark|
        bookmark.folder_id = no_folder.id
        bookmark.save
      end
    end
    folder.destroy
    respond_to do |format|
      format.js { @folders = current_user.folders.where('name <> ?', 'no_folder') }
    end
  end

  def edit
    @folder = Folder.find(params[:id])
  end

  def update
    folder = Folder.find(params[:id])
    folder.update_attributes(params[:folder])
    respond_to do |format|
      format.js { @folders = current_user.folders.where('name <> ?', 'no_folder') }
    end
  end

  def show
  end

  def index
    @folders = current_user.folders.where('name <> ?', 'no_folder')
  end

  def delete_form
    @folder = Folder.find(params[:id])
  end
end
