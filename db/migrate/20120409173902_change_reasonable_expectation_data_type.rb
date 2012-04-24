class ChangeReasonableExpectationDataType < ActiveRecord::Migration
  def up
    remove_column :tasks, :reasonable_expectation
    add_column :tasks, :reasonable_expectation, :int
  end

  def down
  end
end
