class Answer < Message
  acts_as_commentable
  belongs_to :question, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type

  before_validation do
    self.name = self.question.name
  end
end
