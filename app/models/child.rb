class Child < ActiveRecord::Base
  attr_accessible :name
  has_many :grand_children, :dependent => :destroy
  belongs_to :parent
end
