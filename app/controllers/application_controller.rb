class ApplicationController < ActionController::Base
  before_filter :signed_in_user, :update_user_last_request_at, :include_username_in_log
  protect_from_forgery
  include SessionsHelper
  check_authorization #cancan

  rescue_from CanCan::AccessDenied do |exception|
  #flash.now[:notice] = exception.message
  #redirect_to :back
  redirect_to :home, notice: exception.message
  end

  private

  def signed_in_user
    unless signed_in?
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def update_user_last_request_at
    unless current_user.nil?
      current_user.skip_password_validation = true
      current_user.do_not_reset_session = true
      current_user.last_request_at = DateTime.now
      current_user.save
    end
  end

  def include_username_in_log
    unless current_user.nil?
      logger.info "Request made by #{current_user.username}."
    end
  end
end
