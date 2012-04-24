class SessionsController < ApplicationController

  skip_before_filter :signed_in_user, only: [:create, :new]
  skip_authorization_check

  def new
  end

  def create
    user = User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to home_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to signin_path, notice: "You have successfully logged out."
  end
end
