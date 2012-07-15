class Comment < Message
  def self.judgeds
    [:question, :answer, :publication]
  end
  acts_as_searchable
  belongs_to :judged, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type

  before_validation do
    if self.judged
      self.name ||= self.judged.name
    end
  end

  def judged_name
    self.judged_resource.name
  end

  def judged_resource
    if self.judged.is_a?(Answer) 
      return self.judged.question
    else
      return self.judged
    end
  end

end
