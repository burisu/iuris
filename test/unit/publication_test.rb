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

require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
