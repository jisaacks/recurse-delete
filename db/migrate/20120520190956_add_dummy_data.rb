class AddDummyData < ActiveRecord::Migration
  def up
    names = %w{ Henry Frank Sally Jeremy John Cindy Christina Kim Ian Jim Stan }
    for i in 0..10
      p = Parent.create!(:name => names[i])
      for j in 0..10
        c = Child.create!(:name => names[j])
        p.children << c
        for k in 0..10
          g = GrandChild.create!(:name => names[k])
          c.grand_children << g
          for l in 0..10
            gg = GreatGrandChild.create!(:name => names[l])
            g.great_grand_children << gg
          end
        end
      end
    end
  end

  def down
    Parent.destroy_all
  end
end
