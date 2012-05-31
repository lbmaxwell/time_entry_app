class TimeEntriesController < ApplicationController
  include TimeEntriesHelper
  load_and_authorize_resource
  #skip_authorization_check
  # GET /time_entries
  # GET /time_entries.json
  def index
    @teams = current_user.teams_managed
    @selected_team = params[:team] ||= current_user.teams_managed.first

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

    @time_entries = TimeEntry.where(effective_date: @begin..@end, team_id: @selected_team)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @time_entries }
    end
  end

  # GET /time_entries/1
  # GET /time_entries/1.json
  def show
    @time_entry = TimeEntry.find(params[:id])
    @comments = Comment.where(time_entry_id: params[:id]).reverse!

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_entry }
    end
  end

  # GET /time_entries/new
  # GET /time_entries/new.json
  def new
    @hide_number_processed = true
    @hide_time_value_fields = true
    @last_time_entry = current_user.time_entries.last
    @time_entry = TimeEntry.new

    @show_change_team_link = true
    @team = current_user.team
    @users = users_for_dropdown
    @tasks = current_user.team.tasks.where(is_active: true)
    @tasks.sort! { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_entry }
    end
  end

  # GET /time_entries/1/edit
  def edit
    @time_entry = TimeEntry.find(params[:id])
    @hide_number_processed = !@time_entry.task.is_direct? 
    @hide_time_value_fields = @time_entry.task.is_direct?

    @show_change_team_link = false
   
    @team = @time_entry.team
    @users = users_for_dropdown

    @tasks = @time_entry.team.tasks#current_user.team.tasks.where(is_active: true)
    @tasks.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @tasks = current_user.team.tasks.where(is_active: true)

    @users = users_for_dropdown

    unless params[:time_entry][:task_id].empty?
      task = Task.find(params[:time_entry][:task_id])

      #Do not allow submission if a comment is not provided for "Other" tasks
      if task.name.downcase == 'other' && params[:comment].empty?
        flash.now[:error] = 'A comment is required for "Other" tasks.'
        render 'new' and return
      end

      if task.task_inventory.is_direct
        params[:time_entry][:seconds] = task.expectation_in_seconds
      else
        params[:time_entry][:seconds] = calculate_seconds_from_form
      end
    end

    if params[:time_entry][:user_id].nil? || params[:time_entry][:user_id].empty?
      params[:time_entry][:user_id] = current_user.id
    end

    params[:time_entry][:team_id] = current_user.team.id
    @tasks = current_user.team.tasks
    @time_entry = TimeEntry.new(params[:time_entry])
    @time_entry.skip_date_range_check = current_user.admin?

    respond_to do |format|
      if @time_entry.save
        Comment.create(comment: params[:comment], time_entry: @time_entry,
          user: current_user) unless params[:comment].empty?
        format.html { redirect_to new_time_entry_path, notice: 'Time entry was successfully created.' }
        format.json { render json: @time_entry, status: :created, location: @time_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /time_entries/1
  # PUT /time_entries/1.json
  def update
    seconds = params[:time_entry][:seconds].to_i
    minutes = params[:minutes].to_i
    seconds += (minutes * 60)
    params[:time_entry][:seconds] = seconds

    @time_entry = TimeEntry.find(params[:id])
    @tasks = @time_entry.team.tasks.where(is_active: true)

    respond_to do |format|
      if @time_entry.update_attributes(params[:time_entry])
        format.html { redirect_to home_path, notice: 'Time entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    @time_entry = TimeEntry.find(params[:id])
    @time_entry.destroy

    respond_to do |format|
      format.html { redirect_to home_path }
      format.json { head :no_content }
    end
  end

  def is_task_direct #Used to handle AJAX requests for new time entries form
    task = Task.find(params[:task_id])
    @is_task_direct = task.task_inventory.is_direct

    respond_to do |format|
      format.js
    end
  end
end
