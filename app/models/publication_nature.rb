class PublicationNature < ActiveRecord::Base
  def self.name_columns
    [:title, :source, :reference, :date]
  end

  attr_accessible :name, :title_format
  default_scope order(:name)


  before_validation do
    for x in self.class.name_columns
      self.send("need_#{x}=", (self.title_format.to_s.match(/\[#{x.to_s.upcase}\]/) ? true : false))
    end
  end
  
  def need
    return self.class.name_columns.collect do |x|
      "models.publication_nature.name_columns.#{x}".t if self.send("need_#{x}?")
    end.compact.sort.to_sentence
  end

  def need?(column)
    self.send("need_#{column}?")
  end

end
