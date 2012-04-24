class StaticPagesController < ApplicationController
  include StaticPagesHelper
  #skip_authorization_check

  def home
      #start_date and end_date are defined in StaticPagesHelper
      @time_entries = current_user.time_entries.where(
        effective_date: start_date..end_date)
  end

  def admin
  end

  def operating_report
    @teams = current_user.teams_managed

    @selected_team_id = params[:team] ||= current_user.team_id

    @users = Team.find(@selected_team_id).users
    @tasks = Team.find(@selected_team_id).tasks

    if params[:users].nil? || params[:users].first == ''
    @time_entries = TimeEntry.where(team_id: @selected_team_id,
          effective_date: start_date..end_date)
    else
    @time_entries = TimeEntry.where(user_id: params[:users],
          effective_date: start_date..end_date)
    end

    @summed_time_hash = Hash.new

    (start_date..end_date).each do |date|
      @summed_time_for_task = Hash.new
      @tasks.each do |task|
        time = 0
        @time_entries.each do |time_entry|
          if time_entry.task == task && time_entry.effective_date == date
            time += time_entry.seconds
          end
        end
        @summed_time_for_task[task.id] = (time.to_f / 60).round(2)
      end
      @summed_time_hash[date] = @summed_time_for_task
    end

    respond_to do |format|
      format.html
    end

    def users_for_team #Used for AJAX to populate users control based on team selection
      @selected_team_id = params[:team_id] ||= current_user.team_id
      @users = Team.find(@selected_team_id).users

      respond_to do |format|
        format.js
      end
    end
  end
end
