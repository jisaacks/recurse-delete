class Parent < ActiveRecord::Base
  attr_accessible :name
  has_many :children, :dependent => :destroy
end
