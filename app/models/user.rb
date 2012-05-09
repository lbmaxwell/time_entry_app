class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :team_id
  attr_accessor :skip_password_validation 
  has_secure_password
  before_save :create_remember_token

  has_many :assignments
  has_many :comments
  has_many :time_entries
  has_many :paid_time_entries
  belongs_to :team

  validates :password, length: { within: 6..40 }, :unless => :skip_password_validation
  validates :password_confirmation, presence: true, :unless => :skip_password_validation
  validates :team_id, presence: true

  def admin?
    self.assignments.each do |a|
      return true if a.role.name == 'manager'
    end
    false
  end

  def teams
    teams = Array.new
    self.assignments.each do |a|
      teams.push(a.team)
    end
    teams
  end

  def teams_managed
    teams_managed = Array.new
    self.assignments.each do |a|
      if a.role.name == 'manager'
        teams_managed.push(a.team)
      end
    end
    teams_managed
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
