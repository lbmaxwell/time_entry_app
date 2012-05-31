module TimeEntriesHelper
  def calculate_seconds_from_form
    seconds = params[:minutes].to_i * 60
    seconds += params[:time_entry][:seconds].to_i
  end

  def input_params_to_date(date_hash)
    date = date_hash[:year]
    date += '-'
    date += date_hash[:month]
    date += '-'
    date += date_hash[:day]
    date = date.to_date
  end

  def users_for_dropdown
    if current_user.admin? && current_user.teams_managed.include?(current_user.team)
      @users = current_user.team.users.sort! do |a,b|
        a.username.downcase <=> b.username.downcase
      end
    else
      @users = [current_user]
    end
  end
#  def start_date
#    if params[:start_date].nil?
#      start_date = Date.today #first_day_in_week
#    else
#      start_date = input_params_to_date(params[:start_date])
#    end
#  end
#
#  def end_date
#    if params[:end_date].nil?
#      end_date = Date.today #last_day_in_week
#    else
#      end_date = input_params_to_date(params[:end_date])
#    end
#  end
end
