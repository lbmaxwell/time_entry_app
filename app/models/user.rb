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

  validates :username, uniqueness: true
  validates :password, length: { within: 6..20 }, :unless => :skip_password_validation
  validates :password_confirmation, presence: true, :unless => :skip_password_validation
#  validates :team_id, presence: true #Removed when implementing assignment expiration features

  def admin?
    self.assignments.each do |a|
      return true if a.role.name == 'manager'
    end
    false
  end

  def teams
    teams = Array.new
    self.assignments.each do |a|
      teams.push(a.team) if a.end_date.nil? || a.end_date >= Date.today
    end
    teams
  end

  def teams_managed
    teams_managed = Array.new
    self.assignments.each do |a|
      if a.role.name == 'manager'
        teams_managed.push(a.team) if a.end_date.nil? || a.end_date >= Date.today
      end
    end
    teams_managed
  end

  def active_assignments
    a = Assignment.where(user_id: self.id, 
        end_date: [nil,Date.today..1000.years.from_now.to_date])
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
