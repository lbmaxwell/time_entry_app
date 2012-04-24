class TaskInventory < ActiveRecord::Base
  has_many :tasks
  attr_accessible :name
  validates :name, presence: true
end
