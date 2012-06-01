class PerformanceBoardController < ApplicationController
  include PerformanceBoardHelper
  skip_authorization_check

  def index
    @show_performance = true

    @date = date_for_time_entries

    if current_user.admin?
      @teams = current_user.teams_managed
      @team = Team.find(params[:team] ||= current_user.teams_managed.first)

      @users = team_members(@team)
      @users.sort! { |a,b| a.username <=> b.username }
    else
      @teams = current_user.teams
      @team = Team.find(params[:team] ||= current_user.team)
      @show_performance = @team.show_performance
      @users = [current_user]
    end

    @tasks = tasks_for_performance_board
#    @table_data = Hash.new
#    @table_data[1] = 'hello'
#    @table_data[2] = 'goodbye'
    @table_data = table_data

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
