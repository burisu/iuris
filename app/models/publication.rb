class Publication < ActiveRecord::Base
  acts_as_commentable
  attr_accessible :name, :description, :document, :nature_id, :title_values
  belongs_to :author, :class_name => "User"
  belongs_to :nature, :class_name => "PublicationNature", :counter_cache => true
  has_attached_file :document, :url=>'/:class/:id.pdf', :path=>':rails_root/private/:class/:id_partition/:style.:extension'
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
