class Parameter < ActiveRecord::Base
  def self.natures
    [:string, :document, :boolean, :decimal, :date, :datetime, :record]
  end
  has_attached_file :document_value, {
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
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
