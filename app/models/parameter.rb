class Parameter < ActiveRecord::Base
  attr_accessible :name, :nature, :value, :string_value
  belongs_to :record_value, :polymorphic => true

  def value=(val)
    self.send("#{self.nature}_value=", val)
  end

  def value
    self.send("#{self.nature}_value")
  end

end
