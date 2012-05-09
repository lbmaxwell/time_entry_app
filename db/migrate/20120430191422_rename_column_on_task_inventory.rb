class RenameColumnOnTaskInventory < ActiveRecord::Migration
  def up
    change_table :task_inventories do |t|
      t.rename :track_count, :is_direct
    end
  end

  def down
  end
end
