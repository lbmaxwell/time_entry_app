class TeamPerformanceController < ApplicationController
  include TeamPerformanceHelper
  skip_authorization_check

  def index_temp
  end

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
  end
end
