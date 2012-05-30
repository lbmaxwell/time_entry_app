class TaskInventoriesController < ApplicationController
  authorize_resource
  # GET /task_inventories
  # GET /task_inventories.json
  def index
    @task_inventories = TaskInventory.all.sort! { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @task_inventories }
    end
  end

  # GET /task_inventories/1
  # GET /task_inventories/1.json
  def show
    @task_inventory = TaskInventory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task_inventory }
    end
  end

  # GET /task_inventories/new
  # GET /task_inventories/new.json
  def new
    @task_inventory = TaskInventory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task_inventory }
    end
  end

  # GET /task_inventories/1/edit
  def edit
    @task_inventory = TaskInventory.find(params[:id])
  end

  # POST /task_inventories
  # POST /task_inventories.json
  def create
    @task_inventory = TaskInventory.new(params[:task_inventory])

    respond_to do |format|
      if @task_inventory.save
        format.html { redirect_to @task_inventory, notice: 'Task inventory was successfully created.' }
        format.json { render json: @task_inventory, status: :created, location: @task_inventory }
      else
        format.html { render action: "new" }
        format.json { render json: @task_inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /task_inventories/1
  # PUT /task_inventories/1.json
  def update
    @task_inventory = TaskInventory.find(params[:id])

    respond_to do |format|
      if @task_inventory.update_attributes(params[:task_inventory])
        format.html { redirect_to @task_inventory, notice: 'Task inventory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task_inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_inventories/1
  # DELETE /task_inventories/1.json
  def destroy
    @task_inventory = TaskInventory.find(params[:id])
    @task_inventory.destroy

    respond_to do |format|
      format.html { redirect_to task_inventories_url }
      format.json { head :no_content }
    end
  end
end
