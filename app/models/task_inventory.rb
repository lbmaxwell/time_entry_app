class TaskInventory < ActiveRecord::Base
  has_many :tasks
  attr_accessible :name, :is_direct
  validates :name, presence: true
end
