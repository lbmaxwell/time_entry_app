class AddTeamIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :team_id, :int
  end
end
