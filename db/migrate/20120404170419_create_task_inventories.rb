class CreateTaskInventories < ActiveRecord::Migration
  def change
    create_table :task_inventories do |t|
      t.string :name

      t.timestamps
    end
  end
end
