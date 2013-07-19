class AddMatchIdToGoals < ActiveRecord::Migration
  def up
    add_column :goals, :match_id, :integer
  end

  def down
    remove_column :goals, :match_id
  end
end
