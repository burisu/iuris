# == Schema Information
#
# Table name: parameters
#
#  id                          :integer          not null, primary key
#  name                        :string(255)      not null
#  label                       :string(255)
#  nature                      :string(255)      not null
#  document_value_file_name    :string(255)
#  document_value_file_size    :integer
#  document_value_content_type :string(255)
#  document_value_updated_at   :datetime
#  document_value_fingerprint  :string(255)
#  string_value                :string(255)
#  boolean_value               :boolean
#  decimal_value               :decimal(, )
#  date_value                  :date
#  datetime_value              :datetime
#  record_value_id             :integer
#  record_value_type           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  lock_version                :integer          default(0), not null
#

require 'test_helper'

class ParameterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
