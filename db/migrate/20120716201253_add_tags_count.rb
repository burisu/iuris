class AddTagsCount < ActiveRecord::Migration
  def up
    add_column :labels, :tags_count, :integer, :null => false, :default => 0
    execute "UPDATE labels SET tags_count = counts.val FROM (SELECT label_id, COUNT(id) AS val FROM tags GROUP BY label_id) AS counts WHERE labels.id = counts.label_id"
  end

  def down
    remove_column :labels, :tags_count
  end
end
