class RemovePasswordFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :password
  end

  def down
  end
end
