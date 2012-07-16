class Tag < ActiveRecord::Base
  attr_accessible :label, :tagged
  belongs_to :label, :counter_cache => true
  belongs_to :tagged, :polymorphic => true

  validate(:on => :create) do
    errors.add(:label_id, :unique) if Tag.where("label_id=? AND tagged_id = ? AND tagged_type = ?", self.label_id, self.tagged_id, self.tagged_type).first
  end

  validate(:on => :update) do
    errors.add(:label_id, :unique) if Tag.where("id != ? AND label_id=? AND tagged_id = ? AND tagged_type = ?", self.id, self.label_id, self.tagged_id, self.tagged_type).first
  end
end
