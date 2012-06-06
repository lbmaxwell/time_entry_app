class PaidTimeEntriesController < ApplicationController
  authorize_resource
  include PaidTimeEntriesHelper
  # GET /paid_time_entries
  # GET /paid_time_entries.json
  def index
    if current_user.admin?
      @teams = current_user.teams_managed
      @selected_team = params[:team] ||= current_user.teams_managed.first
    else
      @teams = current_user.teams
    end

    if params[:start_date].nil?
      @begin = (Date.today - 7)
    else
      @begin = input_params_to_date(params[:start_date])
    end

    if params[:end_date].nil?
      @end = Date.today
    else
      @end = input_params_to_date(params[:end_date])
    end

    if current_user.admin?
      @paid_time_entries = PaidTimeEntry.where(effective_date: @begin..@end, team_id: @selected_team)
    else
      @paid_time_entries = PaidTimeEntry.where(effective_date: @begin..@end, user_id: current_user.id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @paid_time_entries }
    end
  end

  # GET /paid_time_entries/1
  # GET /paid_time_entries/1.json
  def show
    @paid_time_entry = PaidTimeEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @paid_time_entry }
    end
  end

  # GET /paid_time_entries/new
  # GET /paid_time_entries/new.json
  def new
    @paid_time_entry = PaidTimeEntry.new
    @teams = current_user.teams
    @teams.sort! { |a,b| a.name <=> b.name }
    @team = current_user.team
    @user = current_user

    if current_user.admin? && current_user.teams_managed.include?(@team)
      @users = team_members(@team)
    else
      @users = [current_user]
    end

    @users.sort! { |a,b| a.username <=> b.username }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @paid_time_entry }
    end
  end

  # GET /paid_time_entries/1/edit
  def edit
    @paid_time_entry = PaidTimeEntry.find(params[:id])
    @user = @paid_time_entry.user
    @team = @paid_time_entry.team

    if current_user.admin? && current_user.teams_managed.include?(@team)
      @users = team_members(@team)
    else
      @users = [current_user]
    end

    @users.sort! { |a,b| a.username <=> b.username }    
    
    @teams = @paid_time_entry.user.teams
    @teams.sort! { |a,b| a.name <=> b.name }
  end

  # POST /paid_time_entries
  # POST /paid_time_entries.json
  def create
    @teams = current_user.teams

    if current_user.admin?
      if params[:paid_time_entry][:user_id].empty?
        params[:paid_time_entry][:user_id] = current_user.id
      end
    else
      params[:paid_time_entry][:user_id] = current_user.id
    end

    params[:paid_time_entry][:minutes] = ((params[:hours].to_i * 60) + params[:minutes].to_i)
    @paid_time_entry = PaidTimeEntry.new(params[:paid_time_entry])
    @paid_time_entry.skip_date_range_check = current_user.admin?

    respond_to do |format|
      if @paid_time_entry.save
        format.html { redirect_to @paid_time_entry, notice: 'Paid time entry was successfully created.' }
        format.json { render json: @paid_time_entry, status: :created, location: @paid_time_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @paid_time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /paid_time_entries/1
  # PUT /paid_time_entries/1.json
  def update
    if current_user.admin?
      if params[:paid_time_entry][:user_id].empty?
        params[:paid_time_entry][:user_id] = current_user.id
      end
    else
      params[:paid_time_entry][:user_id] = current_user.id
    end

    @paid_time_entry = PaidTimeEntry.find(params[:id])
    @paid_time_entry.skip_date_range_check = current_user.admin?

    respond_to do |format|
      if @paid_time_entry.update_attributes(params[:paid_time_entry])
        format.html { redirect_to @paid_time_entry, notice: 'Paid time entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @paid_time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paid_time_entries/1
  # DELETE /paid_time_entries/1.json
  def destroy
    @paid_time_entry = PaidTimeEntry.find(params[:id])
    @paid_time_entry.destroy

    respond_to do |format|
      format.html { redirect_to paid_time_entries_url }
      format.json { head :no_content }
    end
  end

  def users_for_team #Used for AJAX to populate users control based on team selection
    if params[:team_id].nil? || params[:team_id].empty?
      @team = current_user.team
    else
      @team = Team.find(params[:team_id])
    end

    if current_user.admin? && current_user.teams_managed.include?(@team)
      @users = team_members(@team)
    else
      @users = [current_user]
    end
    #@selected_team_id = params[:team_id] ||= current_user.team_id

    #@users = team_members(Team.find(@selected_team_id))
    @users.sort! { |a,b| a.username <=> b.username }

    respond_to do |format|
      format.js
    end
  end
end
