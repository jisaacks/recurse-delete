class GrandChild < ActiveRecord::Base
  attr_accessible :name
  has_many :great_grand_children, :dependent => :destroy
  belongs_to :child
end
