class FoldersController < ApplicationController
  def new
    @folder = Folder.new
  end

  def create
    @folder = current_user.folders.build(params[:folder])
    if @folder.save
      flash[:success] = "Bookmarks successfully created."
      redirect_to bookmarks_path
    else
      render 'new'
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
