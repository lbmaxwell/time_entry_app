class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.date :start_date
      t.date :end_date
      t.references :user
      t.references :role
      t.references :team

      t.timestamps
    end
    add_index :assignments, :user_id
    add_index :assignments, :role_id
    add_index :assignments, :team_id
  end
end
