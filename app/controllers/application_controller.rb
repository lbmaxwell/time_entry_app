class ApplicationController < ActionController::Base
  before_filter :signed_in_user
  protect_from_forgery
  include SessionsHelper
  check_authorization #cancan

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_path, notice: exception.message
  end

  private

  def signed_in_user
    unless signed_in?
      redirect_to signin_path, notice: "Please sign in."
    end
  end
end
