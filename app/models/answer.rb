class Answer < Message
  attr_accessible :question
  acts_as_commentable
  acts_as_searchable
  belongs_to :question, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type

  before_validation do
    self.name = self.question.name
  end
end
