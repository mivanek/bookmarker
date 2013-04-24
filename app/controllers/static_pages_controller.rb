class StaticPagesController < ApplicationController
  def index
    flash.keep
    redirect_to bookmarks_path if signed_in?
  end
end
