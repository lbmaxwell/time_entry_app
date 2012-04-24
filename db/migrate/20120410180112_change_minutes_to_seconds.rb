class ChangeMinutesToSeconds < ActiveRecord::Migration
  def up
    change_table :time_entries do |t|
      t.rename :minutes, :seconds
    end

    change_table :tasks do |t|
      t.rename :reasonable_expectation, :expectation_in_seconds
    end
  end

  def down
  end
end
