class CreateMatches < ActiveRecord::Migration
  def up
    create_table :matches do |t|
      t.timestamps
    end
  end

  def down
    drop_table :matches
  end
end
