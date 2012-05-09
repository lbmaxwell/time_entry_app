class ChangeTimeDataTypeForPaidTimeEntry < ActiveRecord::Migration
  def up
    change_table :paid_time_entries do |t|
      t.change :time, :integer
    end
  end

  def down
  end
end
