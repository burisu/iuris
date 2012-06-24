class Question < Message
  acts_as_commentable
  has_many :answers, :as => :origin, :order => "updated_at DESC"
  validates_presence_of :name
  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

end
