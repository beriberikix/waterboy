class Match < ActiveRecord::Base

  def self.delete_goal!(team)
    # TODO(samstern): Check to make sure not deleting 0th goal
    # TODO(samstern): Check that there is not a string of empty matches
    Goal.last_goal(team).destroy
    Match.current.destroy if Match.current.empty?
  end

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
    last_match = Match.last

    if (last_match.nil? || last_match.over?)
      return Match.create!
    else
      return last_match
    end
  end

  def over?
     blue_goals = goals_by("blue").count
     red_goals = goals_by("red").count

     diff = (blue_goals - red_goals).abs
     top_score = [blue_goals, red_goals].max

     return (diff >= 2) && (top_score >= 10)
  end

  def empty?
    goals.count == 0
  end

end
