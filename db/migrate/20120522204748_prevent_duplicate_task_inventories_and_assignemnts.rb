class PreventDuplicateTaskInventoriesAndAssignemnts < ActiveRecord::Migration
  def up
    #I actually modified the TaskInventory model to add uniqueness constraint.
    #execute<<-SQL
    #  ALTER TABLE assignments ADD CONSTRAINT unique_user_id_and_team_id UNIQUE(user_id,team_id);
    #SQL

    #Migration failed, so I ran the constraint above directly in the prod db w/o issue.
  end

  def down
  end
end
