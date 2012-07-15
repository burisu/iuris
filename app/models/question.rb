class Question < Message
  acts_as_commentable
  has_many :answers, :as => :origin, :order => "updated_at DESC"
  validates_presence_of :name
  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }
#  acts_as_searchable :joins_sql => "INNER JOIN messages AS answers_messages" ON "answers_messages"."origin_id" = "messages"."id" AND "answers_messages"."type" IN ('Answer') AND "answers_messages"."origin_type" = 'Message' INNER JOIN "messages" "comments_messages" ON "comments_messages"."origin_id" = "answers_messages"."id" AND "comments_messages"."type" IN ('Comment') AND "comments_messages"."origin_type" = 'Message' INNER JOIN "messages" "comments_messages_2" ON "comments_messages_2"."origin_id" = "messages"."id" AND "comments_messages_2"."type" IN ('Comment') AND "comments_messages_2"."origin_type" = 'Message'", :joins_table => {:}
  #:joins => [{ :answers => :comments}, :comments]

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

end
