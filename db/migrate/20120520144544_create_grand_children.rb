class CreateGrandChildren < ActiveRecord::Migration
  def change
    create_table :grand_children do |t|
      t.string  :name
      t.integer :child_id

      t.timestamps
    end
  end
end
