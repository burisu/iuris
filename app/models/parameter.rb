class Parameter < ActiveRecord::Base
  def self.natures
    [:string, :document, :boolean, :decimal, :date, :datetime, :record]
  end
  attr_accessible :name, :label, :nature, :value, :string_value
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

end
