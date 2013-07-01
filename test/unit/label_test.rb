# == Schema Information
#
# Table name: labels
#
#  id                       :integer          not null, primary key
#  name                     :string(255)      not null
#  description              :text
#  usable_with_questions    :boolean
#  usable_with_publications :boolean
#  usable_with_templates    :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  lock_version             :integer          default(0), not null
#  tags_count               :integer          default(0), not null
#

require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
