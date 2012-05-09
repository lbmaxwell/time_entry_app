class HomeController < ApplicationController
  include HomeHelper
  skip_authorization_check

  def index
    @start_date = start_date
    @end_date = end_date

    @time_entries = current_user.time_entries.where(
      effective_date: start_date..end_date)
  end
end
