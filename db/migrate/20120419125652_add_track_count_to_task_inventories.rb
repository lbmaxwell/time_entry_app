class AddTrackCountToTaskInventories < ActiveRecord::Migration
  def change
      add_column :task_inventories, :track_count, :boolean
  end
end
