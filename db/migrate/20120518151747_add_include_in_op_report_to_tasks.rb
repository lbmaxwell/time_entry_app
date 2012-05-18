class AddIncludeInOpReportToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :include_in_op_report, :boolean
  end
end
