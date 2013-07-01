# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  author_id    :integer          not null
#  origin_id    :integer
#  origin_type  :string(255)
#  type         :string(255)      not null
#  name         :string(255)      not null
#  content      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#  tags_list    :text
#

class Message < ActiveRecord::Base
  attr_accessible :name, :content
  belongs_to :author, :class_name => "User"
  validates_presence_of :author
  audited :allow_mass_assignment => true
end
