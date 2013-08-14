class AddPlayerFieldsToMatches < ActiveRecord::Migration
  def up
    add_column :matches, :b1_id, :integer
    add_column :matches, :b2_id, :integer
    add_column :matches, :r1_id, :integer
    add_column :matches, :r2_id, :integer
  end

  def down
    remove_column :matches, :b1_id
    remove_column :matches, :b2_id
    remove_column :matches, :r1_id
    remove_column :matches, :r2_id
  end
end
