# == Schema Information
#
# Table name: tags
#
#  id           :integer          not null, primary key
#  label_id     :integer          not null
#  tagged_id    :integer          not null
#  tagged_type  :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
