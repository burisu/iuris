class Message < ActiveRecord::Base
  attr_accessible :name, :content
  belongs_to :author, :class_name => "User"
  validates_presence_of :author
  audited :allow_mass_assignment => true
end
