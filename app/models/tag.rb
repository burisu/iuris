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

  after_save do
    self.tagged.save
  end

  after_destroy do
    self.tagged.save
  end

end
