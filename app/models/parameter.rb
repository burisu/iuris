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

class Parameter < ActiveRecord::Base
  def self.natures
    [:string, :document, :boolean, :decimal, :date, :datetime, :record]
  end
  has_attached_file :document_value, {
    :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename",
    :url => "/system/:class/:attachment/:id_partition/:style/:filename"
  }
  attr_accessible :name, :label, :nature, :value, :string_value, :document_value
  belongs_to :record_value, :polymorphic => true

  def value=(val)
    self.send("#{self.nature}_value=", val)
  end

  def value
    self.send("#{self.nature}_value")
  end

  def self.[](name)
    if parameter = self.find_by_name(name)
      return parameter.value
    else
      return "[Parameter missing: #{name}]"
    end    
  end

  def self.has?(name)
    return (self.find_by_name(name) ? true : false)
  end

end
