class Goal < ActiveRecord::Base

  belongs_to :match

  def self.last_goal(team)
    where(team: team).order('updated_at desc').first
  end

  def self.last_ten(team)
    where(team: team).order('updated_at desc').limit(10)
  end

end
