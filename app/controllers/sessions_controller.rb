class SessionsController < ApplicationController

  def new
  end

  def create
    if signed_in? && !current_user.try(:demo)
      redirect_to root_path
    end
    user = User.find_by_email(params[:email].downcase)
    if user.demo
      sign_in user, false
      redirect_to edit_user_path(user) and return
    end
    if user && user.authenticate(params[:password])
      sign_in user, params[:persisted_login]
      redirect_back_or root_path
    else
      flash.now[:error] = "Invalid password/email combination"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
