class PublicationNature < ActiveRecord::Base
  attr_accessible :name, :title_format
  default_scope order(:name)

  before_validation do
    # Find and extract fields
  end
end
