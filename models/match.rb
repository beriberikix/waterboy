class Match < ActiveRecord::Base

  has_many :goals

  def self.delete_goal!(team)
    # TODO(samstern): Check to make sure not deleting 0th goal
    # TODO(samstern): Check that there is not a string of empty matches
    Goal.last_goal(team).destroy
    Match.current.destroy if Match.current.empty?
  end

  # Get a player by team and position
  # Params:
  # +team+: symbol for the team (:red or :blue)
  # +position+: int for the position (1 or 2)
  def get_player(team, position)
    if team.eql?(:red)
      if position == 1
        Player.find(r1_id)
      elsif position == 2
        Player.find(r2_id)
      end
    elsif team.eql?(:blue)
      if position == 1
        Player.find(b1_id)
      elsif position == 2
        Player.find(b2_id)
      end
    end
  end

  # Set a player by team and position
  # Params:
  # +team+: symbol for the team (:red or :blue)
  # +position+: int for the position (1 or 2)
  # +player+: the player object to set
  def set_player!(team, position, player)
    if team.eql?(:red)
      if position == 1
        self.r1_id = player.id
      elsif position == 2
        self.r2_id = player.id
      end
    elsif team.eql?(:blue)
      if position == 1
        self.b1_id = player.id
      elsif position == 2
        self.b2_id = player.id
      end
    end

    save!
  end

  def record_goal!(team)
    Goal.new(team: team, match_id: id).save!
  end

  def goals_by(team)
    goals.find_all { |x| x.team == team }
  end

  def self.current
    last_match = Match.last

    if (last_match.nil?)
      return Match.create!
    elsif (last_match.over?)
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
