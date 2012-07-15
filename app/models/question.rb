class Question < Message
  acts_as_commentable
  acts_as_searchable
  has_many :answers, :as => :origin, :order => "updated_at DESC"
  validates_presence_of :name
  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  before_validation do
    self.name = self.name.strip + "?"
    self.name.gsub!(/[\s\?]+$/, " ?")
    self.name = self.name.mb_chars[0..0].upcase + self.name.mb_chars[1..-1]
    return true
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

end
