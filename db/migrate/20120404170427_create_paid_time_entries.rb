class CreatePaidTimeEntries < ActiveRecord::Migration
  def change
    create_table :paid_time_entries do |t|
      t.time :time
      t.date :effective_date
      t.references :user
      t.references :team

      t.timestamps
    end
    add_index :paid_time_entries, :user_id
    add_index :paid_time_entries, :team_id
  end
end
