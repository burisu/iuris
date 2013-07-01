# == Schema Information
#
# Table name: publications
#
#  id                    :integer          not null, primary key
#  author_id             :integer          not null
#  nature_id             :integer          not null
#  name                  :text             not null
#  description           :string(255)
#  title_values          :text
#  origin                :string(255)      not null
#  url                   :text
#  state                 :string(255)
#  document_file_name    :string(255)
#  document_file_size    :integer
#  document_content_type :string(255)
#  document_updated_at   :datetime
#  document_fingerprint  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  lock_version          :integer          default(0), not null
#  tags_list             :text
#

class Publication < ActiveRecord::Base
  acts_as_commentable
  acts_as_searchable
  acts_as_taggable
  attr_accessible :name, :description, :document, :nature_id, :title_values
  belongs_to :author, :class_name => "User"
  belongs_to :nature, :class_name => "PublicationNature", :counter_cache => true
  has_attached_file :document, {
    :url=>'/:class/:id.pdf', 
    :path=>':rails_root/private/:class/:id_partition/:style.:extension'
  }
  validates_attachment_content_type :document, :content_type => ["application/x-pdf", "application/pdf"]
  validates_attachment_presence :document
  validates_presence_of :nature
  serialize :title_values, Hash
  delegate :logo, :to => :nature
 # acts_as_searchable :joins => :comments 

  default_scope :include => :nature
  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  before_validation do
    self.name = self.nature.format_title(self.title_values)
    self.origin = "document"
    self.state = "published"
  end

end
