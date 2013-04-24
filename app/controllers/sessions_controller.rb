class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
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
