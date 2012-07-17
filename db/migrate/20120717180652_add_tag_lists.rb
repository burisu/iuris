class AddTagLists < ActiveRecord::Migration
  def up
    add_column :messages, :tags_list, :text
    add_column :publications, :tags_list, :text

    Question.find_each do |x|
      x.save
    end
    
    Publication.find_each do |x|
      x.save
    end
    
  end

  def down
    remove_column :publications, :tags_list
    remove_column :messages, :tags_list
  end
end
