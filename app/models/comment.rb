class Comment < ActiveRecord::Base
  belongs_to :time_entry
  belongs_to :user
  attr_accessible :comment, :time_entry, :user

  validates :comment, presence: true, length: { minimum: 1, maximum: 255 }
end
