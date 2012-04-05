class Task < ActiveRecord::Base
  belongs_to :task_inventory
  belongs_to :team
  has_many :time_entries
  attr_accessible :is_active, :reasonable_expectation, :task_inventory_id, :team_id

  def name
    self.task_inventory.name
  end
end
