class Match < ActiveRecord::Base

  def record_goal!(team)
    Goal.new(team: team).save!
  end

  def goals
    Goal.where(['updated_at > ?', created_at])
  end

  def goals_by(team)
    goals.find_all { |x| x.team == team }
  end

  def self.current
    if Match.last.nil?
      match = Match.new
      match.save!
      return match
    else
      return Match.last
    end
  end

end
