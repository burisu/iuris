class Question < Message
  has_many :answers, :as => :origin
  has_many :comments, :as => :origin
  scope :lasts, lambda { |count|
    order("created_at DESC").limit(count)
  }

end
