class RenameTimeToMinutes < ActiveRecord::Migration
  def up
    change_table :time_entries do |te|
      te.rename :time, :minutes
    end
  end

  def down
  end
end
