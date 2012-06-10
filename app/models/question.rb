class Question < Message
  has_many :answers, :as => :origin, :order => "updated_at DESC"
  has_many :comments, :as => :origin
  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

end
