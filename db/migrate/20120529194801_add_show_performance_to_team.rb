class AddShowPerformanceToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :show_performance, :boolean
  end
end
