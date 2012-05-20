class CreateGreatGrandChildren < ActiveRecord::Migration
  def change
    create_table :great_grand_children do |t|
      t.string :name
      t.integer :grand_child_id

      t.timestamps
    end
  end
end
