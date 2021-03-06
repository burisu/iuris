# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  author_id    :integer          not null
#  origin_id    :integer
#  origin_type  :string(255)
#  type         :string(255)      not null
#  name         :string(255)      not null
#  content      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#  tags_list    :text
#

class Comment < Message
  def self.judgeds
    [:question, :answer, :publication]
  end
  acts_as_searchable
  belongs_to :judged, :polymorphic => true, :foreign_key => :origin_id, :foreign_type => :origin_type

  before_validation do
    if self.judged
      self.name ||= self.judged.name
    end
  end

  def judged_name
    self.judged_resource.name
  end

  def judged_resource
    if self.judged.is_a?(Answer) 
      return self.judged.question
    else
      return self.judged
    end
  end

  def last?
    if c = self.class.where(:origin_id => self.origin_id).reorder("id DESC").first
      return true if c.id == self.id
    end
    return false
  end

end
