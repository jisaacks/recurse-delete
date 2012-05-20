class GreatGrandChild < ActiveRecord::Base
  attr_accessible :name
  belongs_to :grand_child
end
