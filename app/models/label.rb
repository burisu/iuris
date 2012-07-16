class Label < ActiveRecord::Base
  attr_accessible :name, :description, :usable_with_questions, :usable_with_publications
  has_many :tags, :order => "created_at DESC"
  scope :valids, lambda {
    reorder("tags_count DESC, name").where("tags_count > 0").limit(50)
  }
  default_scope order(:name)

  validates_uniqueness_of :name

  before_validation do
    self.name = self.name.mb_chars[0..0].upcase + self.name.mb_chars[1..-1]
  end


  def usable_with
    return [:questions, :publications].collect do |x|
      "labels.#{x}".t if self.send("usable_with_#{x}?")
    end.compact.sort.to_sentence
  end
  
  def to_param
    self.name
  end

end
