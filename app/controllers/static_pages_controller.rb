class StaticPagesController < ApplicationController
  def index
    redirect_to bookmarks_path if signed_in?
  end
end
