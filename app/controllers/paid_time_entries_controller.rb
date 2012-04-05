class PaidTimeEntriesController < ApplicationController
  # GET /paid_time_entries
  # GET /paid_time_entries.json
  def index
    @paid_time_entries = PaidTimeEntry.all

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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @paid_time_entry }
    end
  end

  # GET /paid_time_entries/1/edit
  def edit
    @paid_time_entry = PaidTimeEntry.find(params[:id])
  end

  # POST /paid_time_entries
  # POST /paid_time_entries.json
  def create
    @paid_time_entry = PaidTimeEntry.new(params[:paid_time_entry])

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
    @paid_time_entry = PaidTimeEntry.find(params[:id])

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
end
