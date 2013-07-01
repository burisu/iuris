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

class Question < Message
  acts_as_commentable
  acts_as_searchable
  acts_as_taggable
  has_many :answers, :as => :origin, :order => "created_at ASC"
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
