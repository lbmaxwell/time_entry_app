class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.time :time
      t.integer :number_processed
      t.date :effective_date
      t.references :task
      t.references :user

      t.timestamps
    end
    add_index :time_entries, :task_id
    add_index :time_entries, :user_id
  end
end
