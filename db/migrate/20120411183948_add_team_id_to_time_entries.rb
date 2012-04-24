class AddTeamIdToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :team_id, :int
  end
end
