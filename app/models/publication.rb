class Publication < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :comments, :as => :origin
  has_attached_file :document, :url=>'/:class/:id.pdf', :path=>':rails_root/private/:class/:id_partition/:style.:extension'
  attr_accessible :name, :description, :document
  validates_attachment_content_type :document, :content_type => ["application/x-pdf", "application/pdf"]
  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  before_validation do
    self.nature = "document"
  end

end
