module TeamPerformanceHelper
  def table_data
  end

  def utilization_for_()
  end
  
  def efficiency
  end

  def productivity
  end

  def get_time_entries
  end

  def get_paid_time_entries
  end

  def team_members(team_param)
    users = []

    team_param.assignments.each do |assignment|
      users.push(assignment.user)
    end
    users.uniq!
    return users
  end

  def input_params_to_date(date_hash)
    date = date_hash[:year] 
    date += '-' 
    date += date_hash[:month]
    date += '-' 
    date += date_hash[:day]
    date = date.to_date
  end

  def first_day_in_week(date = Date.today)
    while date.cwday != 7
      date = date - 1
    end
    date
  end

  def last_day_in_week(date = Date.today)
    while date.cwday != 6
      date = date + 1
    end
    date
  end

  def start_date
    if params[:start_date].nil?
      start_date = first_day_in_week
    else
      start_date = input_params_to_date(params[:start_date])
    end
  end

  def end_date
    if params[:end_date].nil?
      end_date = last_day_in_week
    else
      end_date = input_params_to_date(params[:end_date])
    end
  end
end
