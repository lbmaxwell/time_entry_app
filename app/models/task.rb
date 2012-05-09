class Task < ActiveRecord::Base
  belongs_to :task_inventory
  belongs_to :team
  has_many :time_entries
  attr_accessible :is_active, :expectation_in_seconds, :task_inventory_id, :team_id
  
  #validates :is_active, presence:true
  validates :expectation_in_seconds, presence:true
  validates :task_inventory_id, presence: true
  validates :team_id, presence: true

  def name
    self.task_inventory.name
  end

  def reasonable_expectation
    (self.expectation_in_seconds.to_f / 60).round(2)
  end

  def is_direct?
    (self.task_inventory.is_direct)
  end

  def is_direct
    self.is_direct?
  end
end
