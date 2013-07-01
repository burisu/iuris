# == Schema Information
#
# Table name: publication_natures
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  title_format       :text             not null
#  title_pattern      :text
#  title_fields       :text
#  publications_count :integer          default(0), not null
#  usable             :boolean          default(FALSE), not null
#  logo_file_name     :string(255)
#  logo_file_size     :integer
#  logo_content_type  :string(255)
#  logo_updated_at    :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lock_version       :integer          default(0), not null
#

require 'test_helper'

class PublicationNatureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
