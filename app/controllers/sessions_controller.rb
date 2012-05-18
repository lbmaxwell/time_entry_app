class SessionsController < ApplicationController

  skip_before_filter :signed_in_user, only: [:create, :new]
  skip_authorization_check

  def new
  end

  def create
    user = User.find_by_username(params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.active_assignments.empty?
        flash.now[:error] = 'Unable to complete login, because this user account has no active assignments.'
        render 'new'
      elsif user.team.nil?
        sign_in user
        flash[:error] = 'You will not be able to perform any actions until you select a default team.'
        redirect_to '/change_team'
      else
        sign_in user
        redirect_to home_path
      end
    else
      flash.now[:error] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to signin_path, notice: "You have successfully logged out."
  end
end
