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

class Answer < Message
  attr_accessible :question
  acts_as_commentable
  acts_as_searchable
  belongs_to :question, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type

  before_validation do
    self.name = self.question.name
  end
end
