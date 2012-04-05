class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.time :reasonable_expectation
      t.boolean :is_active
      t.references :task_inventory
      t.references :team

      t.timestamps
    end
    add_index :tasks, :task_inventory_id
    add_index :tasks, :team_id
  end
end
