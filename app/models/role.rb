class Role < ActiveRecord::Base
  attr_accessible :name

  has_many :assignments
  validates :name, presence: true
end
