class Comment < Message
  def self.judgeds
    [:question, :answer, :publication]
  end
  belongs_to :judged, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type

  before_validation do
    if self.judged
      self.name ||= self.judged.name
    end
  end


end
