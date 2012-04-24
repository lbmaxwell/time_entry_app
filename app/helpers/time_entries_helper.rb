module TimeEntriesHelper
  def calculate_seconds_from_form
    seconds = params[:minutes].to_i * 60
    seconds += params[:time_entry][:seconds].to_i
  end
end
