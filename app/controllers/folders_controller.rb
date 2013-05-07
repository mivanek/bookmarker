class FoldersController < ApplicationController
  def new
    @folder = Folder.new
  end

  def create
    @folder = current_user.folders.build(params[:folder])
    if @folder.save
      respond_to do |format|
        format.html do
          flash[:success] = "Bookmarks successfully created."
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
  end

  def edit
  end

  def update
  end

  def show
  end
end
