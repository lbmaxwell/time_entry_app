class ChangePaidTimeEntries < ActiveRecord::Migration
  def up
    change_table :paid_time_entries do |t|
      t.rename :time, :minutes
    end
    
    add_column :paid_time_entries, :is_overtime, :boolean
  end

  def down
  end
end
