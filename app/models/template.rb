# == Schema Information
#
# Table name: templates
#
#  id           :integer          not null, primary key
#  author_id    :integer          not null
#  name         :string(255)      not null
#  state        :string(255)
#  content      :text
#  uses_count   :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#

class Template < ActiveRecord::Base
  # attr_accessible :title, :body
end
