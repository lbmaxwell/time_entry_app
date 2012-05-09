class StaticPagesController < ApplicationController
  include StaticPagesHelper
  skip_authorization_check

  def admin
  end
end
