class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.references :time_entry
      t.references :user

      t.timestamps
    end
    add_index :comments, :time_entry_id
    add_index :comments, :user_id
  end
end
