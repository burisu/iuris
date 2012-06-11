class Label < ActiveRecord::Base
  attr_accessible :name, :description, :usable_with_questions, :usable_with_publications
  
  def usable_with
    return [:questions, :publications].collect do |x|
      "labels.#{x}".t if self.send("usable_with_#{x}?")
    end.compact.sort.to_sentence
  end
end
