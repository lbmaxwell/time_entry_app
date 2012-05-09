module OperatingReportHelper
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

  def table_data(is_daily = false)
    table_data = Hash.new(0)
    tasks = tasks_for_operating_report
    time_entries_local = time_entries
    total_volume = Hash.new(0)
    total_time = Hash.new(0)

    table_data[:indirect_task_count] = tasks.find_all{|t| !t.is_direct?}.count
    table_data[:direct_task_count] = tasks.find_all{|t| t.is_direct?}.count

    if is_daily 
      date_range = (start_date..end_date)
    else
      date_range = last_days_of_week_for_date_range(start_date, end_date)
    end

    date_range.each do |date|
      if is_daily
        regular_paid_time_entries = get_paid_time_entries(date, date, false)
        overtime_paid_time_entries = get_paid_time_entries(date, date, true)
      else
        regular_paid_time_entries = get_paid_time_entries(date - 7, date, false)
        overtime_paid_time_entries = get_paid_time_entries(date - 7, date, true)
      end

      earned_seconds = 0
      nested_hash = Hash.new

      nested_hash[:reg_minutes] = time_entries_minute_total(regular_paid_time_entries)
      nested_hash[:ot_minutes] = time_entries_minute_total(overtime_paid_time_entries)
      nested_hash[:total_minutes] = nested_hash[:reg_minutes] + nested_hash[:ot_minutes]

      total_time[:reg_minutes] += nested_hash[:reg_minutes]
      total_time[:ot_minutes] += nested_hash[:ot_minutes]

      indirect_seconds = 0

      tasks.each do |task|

        seconds = 0
        count = 0

        time_entries_local.each do |time_entry|
          if is_daily
            if time_entry.task == task && time_entry.effective_date == date
              if task.is_direct?
                count += time_entry.number_processed
                seconds += time_entry.seconds * time_entry.number_processed
              else
                indirect_seconds += time_entry.seconds
                seconds += time_entry.seconds
              end
            end
          else
            if (time_entry.task == task && 
                  last_day_in_week(time_entry.effective_date) == date)
              if task.is_direct?
                count += time_entry.number_processed
                seconds += time_entry.seconds * time_entry.number_processed
              else
                indirect_seconds += time_entry.seconds
                seconds += time_entry.seconds
              end
            end
          end
        end # |time_entry|

        if task.is_direct?
          nested_hash[task.id] = count
          total_volume[task.id] += count
          earned_seconds += seconds
        else
          nested_hash[task.id] = seconds_to_hours(seconds)
        end
        total_time[task.id] += seconds
      end # |task|

      nested_hash[:actual_direct_seconds] = ((nested_hash[:total_minutes] * 60) - 
          indirect_seconds)

      if nested_hash[:total_minutes] != 0
        nested_hash[:utilization] = ((nested_hash[:actual_direct_seconds].to_f / 
            (nested_hash[:total_minutes].to_f * 60)) * 100).round(1).to_s + '%'

        nested_hash[:production] = ((earned_seconds.to_f / 
            (nested_hash[:total_minutes].to_f * 60)) * 100).round(1).to_s + '%'
      else
        nested_hash[:utilization] = '-'
        nested_hash[:production] = '-'
      end

      if nested_hash[:actual_direct_seconds] <= 0 
        nested_hash[:efficiency] = '-'
      else
        nested_hash[:efficiency] = ((earned_seconds.to_f / 
            nested_hash[:actual_direct_seconds].to_f) * 100).round(1).to_s + '%'
      end

      table_data[date] = nested_hash
      table_data[:actual_direct_seconds_total] += nested_hash[:actual_direct_seconds]
    end # |date|
    table_data[:total_volume] = total_volume
    table_data[:total_time] = total_time
    return table_data
  end

#  def table_data_weekly
#    table_data = Hash.new
#    tasks = tasks_for_operating_report
#    time_entries_local = time_entries
#    end_dates = last_days_of_week_for_date_range(start_date, end_date)
#    total_volume = Hash.new(0)
#    total_time = Hash.new(0)
#
#    #(start_date..end_date).each do |date|
#    end_dates.each do |date|
#      task_amount = Hash.new(0)
#
#      tasks.each do |task|
#
#        current_task_id = task.id
#        seconds = 0
#        count = 0
#
#        time_entries_local.each do |time_entry|
#          if (time_entry.task == task && 
#               last_day_in_week(time_entry.effective_date) == date)
#            if task.is_direct?
#              count += time_entry.number_processed
#              seconds += time_entry.seconds * time_entry.number_processed
#            else
#              seconds += time_entry.seconds
#            end
#          end
#        end # |time_entry|
#
#        if task.is_direct?
#          task_amount[task.id] = count
#          total_volume[task.id] += count
#        else
#          task_amount[task.id] = (seconds.to_f / 60).round(2)
#        end
#        total_time[task.id] += seconds
#      end # |task|
#      table_data[last_day_in_week(date)] = task_amount
#    end # |date|
#    table_data[:total_volume] = total_volume
#    table_data[:total_time] = total_time
#    return table_data
#  end

  def time_entries
    if current_user.admin?
      if params[:users].nil? || params[:users].first == ''
        @time_entries = TimeEntry.where(team_id: params[:team],
            effective_date: start_date..end_date)
      else
        @time_entries = TimeEntry.where(user_id: params[:users],
            effective_date: start_date..end_date)
      end
    else
    @time_entries = TimeEntry.where(user_id: current_user.id,
          effective_date: start_date..end_date)
    end
  end

  def users_string
    return current_user.username unless current_user.admin?
    users_string = ''
    if params[:users].nil? || params[:users].first == ''
      Team.find(params[:team]).users.each do |user| 
        users_string += "#{user.username}, "
      end
    else
      User.where(id: params[:users]).each do |user|
        users_string += "#{user.username}, "
      end
    end 
    users_string.chop!.chop!
  end

  def last_days_of_week_for_date_range(first_day, last_day)
    days = []
    (first_day..last_day).each do |day|
      days.push(last_day_in_week(day))
    end
    return days.uniq!
  end

  def tasks_for_operating_report
    if current_user.admin?
      tasks = Team.find(params[:team] ||= current_user.teams_managed.first).tasks.where(is_active: true)
    else
      tasks = Team.find(params[:team] ||= current_user.team).tasks.where(is_active: true)
    end
    #Line below reorders task array to put indirect tasks first
    tasks.partition{|task| !task.is_direct?}.flatten
  end

  def get_paid_time_entries(date_param_1, date_param_2, is_overtime = false)
    if current_user.admin?
      team = Team.find(params[:team] ||= current_user.teams_managed.first)
      if params[:users].nil?
        users = team.users
      else
        users = User.find(params[:users])
      end
    else
      team = Team.find(params[:team] ||= current_user.team)
      users = [current_user]
    end
    #The query below works like expected EXCEPT the effective_date param,
    #which is making the query return no results
    PaidTimeEntry.where(team_id: team, user_id: users, 
        is_overtime: is_overtime, effective_date: date_param_1..date_param_2)
    #PaidTimeEntry.all
  end

  def time_entries_minute_total(time_entries_array)
    total_minutes = 0

    time_entries_array.each do |time_entry|
      total_minutes += time_entry.minutes
    end
    total_minutes
  end

  def seconds_to_hours(seconds)
    (seconds.to_f / 3600).round(2)
  end

  def minutes_to_hours(minutes)
    (minutes.to_f / 60).round(2)
  end
end
