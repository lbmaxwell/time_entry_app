class OperatingReportController < ApplicationController
  include OperatingReportHelper
  skip_authorization_check

  def index
    if current_user.admin?
      @teams = current_user.teams_managed
      @team = Team.find(params[:team] ||= current_user.teams_managed.first)

      @users = team_members(@team)
      @users.sort! { |a,b| a.username <=> b.username }
    else
      @teams = current_user.teams
      @team = Team.find(params[:team] ||= current_user.team)
      @users = [current_user]
    end

    @tasks = tasks_for_operating_report

    if params[:display_by_week] == nil || params[:display_by_week] == "true"
      @display_by_week = true
      @report_type = 'Weekly'
    else 
      @display_by_week = false 
      @report_type = 'Daily'
    end
    
    if @display_by_week
      @table_data = table_data(false)
#      @last_days_of_week_selection = last_days_of_week_for_date_range(start_date, end_date)
      @date_range = last_days_of_week_for_date_range(start_date, end_date)
    else
      @table_data = table_data(true)
      @date_range = (start_date..end_date)
    end

      respond_to do |format|
        format.html
        format.js
      end
  end

    def users_for_team #Used for AJAX to populate users control based on team selection
      @selected_team_id = params[:team_id] ||= current_user.team_id
      @users = team_members(Team.find(@selected_team_id))
      @users.sort! { |a,b| a.username <=> b.username }

      respond_to do |format|
        format.js
      end
    end
end
