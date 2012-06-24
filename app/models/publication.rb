class Publication < ActiveRecord::Base
  acts_as_commentable
  attr_accessible :name, :description, :document, :nature_id
  belongs_to :author, :class_name => "User"
  belongs_to :nature, :class_name => "PublicationNature"
  has_attached_file :document, :url=>'/:class/:id.pdf', :path=>':rails_root/private/:class/:id_partition/:style.:extension'
  validates_attachment_content_type :document, :content_type => ["application/x-pdf", "application/pdf"]
  validates_presence_of :nature

  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  before_validation do
    self.name = self.nature.title_format.dup
    self.origin = "document"
    
  end

end
