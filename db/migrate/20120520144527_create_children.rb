class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string  :name
      t.integer :parent_id

      t.timestamps
    end
  end
end
