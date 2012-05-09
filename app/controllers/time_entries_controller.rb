class TimeEntriesController < ApplicationController
  include TimeEntriesHelper
  authorize_resource
  #skip_authorization_check
  # GET /time_entries
  # GET /time_entries.json
  def index
    @time_entries = TimeEntry.all

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
    @last_time_entry = current_user.time_entries.last
    @time_entry = TimeEntry.new
    @tasks = current_user.team.tasks.where(is_active: true)
#    @users = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_entry }
    end
  end

  # GET /time_entries/1/edit
  def edit
    @time_entry = TimeEntry.find(params[:id])
    @tasks = Task.all
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    task = Task.find(params[:time_entry][:task_id])

    if task.task_inventory.is_direct
      params[:time_entry][:seconds] = task.expectation_in_seconds
    else
      params[:time_entry][:seconds] = calculate_seconds_from_form
    end

    params[:time_entry][:user_id] = current_user.id
    params[:time_entry][:team_id] = current_user.team.id
    @tasks = current_user.team.tasks
    @time_entry = TimeEntry.new(params[:time_entry])

    respond_to do |format|
      if @time_entry.save
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
    @time_entry = TimeEntry.find(params[:id])

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
