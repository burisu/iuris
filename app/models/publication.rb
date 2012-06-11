class Publication < ActiveRecord::Base
  NAME_COLUMNS = PublicationNature.name_columns.collect{|x| "name_#{x}".to_sym}.freeze
  def self.name_columns
    NAME_COLUMNS
  end
  attr_accessible :name, :description, :document, :nature_id, *NAME_COLUMNS
  belongs_to :author, :class_name => "User"
  belongs_to :nature, :class_name => "PublicationNature"
  has_many :comments, :as => :origin
  has_attached_file :document, :url=>'/:class/:id.pdf', :path=>':rails_root/private/:class/:id_partition/:style.:extension'
  validates_attachment_content_type :document, :content_type => ["application/x-pdf", "application/pdf"]
  validates_presence_of :nature

  scope :lasts, lambda { |count|
    order("updated_at DESC").limit(count)
  }

  before_validation do
    self.name = self.nature.title_format.dup
    for x in PublicationNature.name_columns
      if self.nature.need?(x)
        self.name.gsub!(/\[#{x.to_s.upcase}\]/, (x == :date ? self.send("name_#{x}").l : self.send("name_#{x}")))
      end
    end
    self.origin = "document"
  end

end
