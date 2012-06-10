class Answer < Message
  belongs_to :question, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type
  has_many :comments, :as => :origin

  before_validation do
    self.name = self.question.name
  end

end
