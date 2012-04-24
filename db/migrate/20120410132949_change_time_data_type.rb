class ChangeTimeDataType < ActiveRecord::Migration
  def up
    remove_column :time_entries, :time
    add_column :time_entries, :time, :int
  end

  def down
  end
end
