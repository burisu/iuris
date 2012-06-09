class Comment < Message
  belongs_to :judged, :polymorphic => true, :foreign_key => :origin_id
end
