class CreateGoals < ActiveRecord::Migration
  def up
    create_table :goals do |t|
      t.string :team

      t.timestamps
    end
  end

  def down
    drop_table :goals
  end
end
