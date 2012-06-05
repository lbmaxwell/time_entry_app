module PerformanceBoardHelper
  def input_params_to_date(date_hash)
    date = date_hash[:year] 
    date += '-' 
    date += date_hash[:month]
    date += '-' 
    date += date_hash[:day]
    date = date.to_date
  end

  def date_for_time_entries
    if params[:date].nil?
      Date.today
    else
      input_params_to_date(params[:date])
    end
  end

  def table_data
    table_data = Hash.new(0)
    tasks = tasks_for_performance_board
    time_entries_local = time_entries
    total_volume = Hash.new(0)
    date = date_for_time_entries
    hour_range = []

    time_entries.each do |te|
      hour_range.push(te.created_at.hour) unless hour_range.include?(te.created_at.hour)
    end

    hour_range.sort!

    hour_range.each do |hour|

      nested_hash = Hash.new

      tasks.each do |task|
        count = 0

        time_entries_local.each do |time_entry|
          if time_entry.task == task && time_entry.created_at.hour == hour
            count += time_entry.number_processed
          end
        end # |time_entry|
        nested_hash[task.id] = count
        table_data[hour] = nested_hash

        # Collect totals for each task
        total_volume[task.id] += count
      end # |task|
    end # |hour|
    
    table_data[:total_volume] = total_volume
    return table_data
  end

  def time_entries
    if current_user.admin?
      if params[:users].nil? || params[:users].first == ''
        @time_entries = TimeEntry.where(team_id: params[:team],
            effective_date: date_for_time_entries)
      else
        @time_entries = TimeEntry.where(user_id: params[:users],
            effective_date: date_for_time_entries)
      end
    else
    @time_entries = TimeEntry.where(user_id: current_user.id,
          effective_date: date_for_time_entries)
    end
  end

  def selected_users_string
    return current_user.username unless current_user.admin?
    users_string = ''

    if params[:team].nil?
      team = current_user.teams_managed.first
    else
      team = Team.find(params[:team])
    end

    usernames_array = []

    if params[:users].nil? || params[:users].first == ''
      team_members(team).each do |user| 
        usernames_array.push(user.username)
      end
    else
      User.where(id: params[:users]).each do |user|
        usernames_array.push(user.username)
      end
    end 
    usernames_array.sort! { |a,b| a <=> b }
    usernames_array.join(", ")
  end

  def team_members(team_param)
    users = []

    team_param.assignments.each do |assignment|
      users.push(assignment.user)
    end
    users.uniq!
    return users
  end

  def tasks_for_performance_board
    if current_user.admin?
      tasks = Team.find(params[:team] ||= current_user.teams_managed.first).tasks.where(
        include_in_op_report: true)
    else
      tasks = Team.find(params[:team] ||= current_user.team).tasks.where(
        include_in_op_report: true)
    end
    #Line below reorders task array to put indirect tasks first
    tasks.delete_if{ |task| !task.is_direct? }
  end

  def hour_int_to_time_string(hour_int)
    if hour_int.to_i > 12
      time_string = "#{hour_int - 12}:00 PM"
    elsif hour_int == 0
      time_string = "12:00 AM"
    elsif hour_int == 12
      time_string = "12:00 PM"
    else
      time_string = "#{hour_int}:00 AM"
    end
  end
end
