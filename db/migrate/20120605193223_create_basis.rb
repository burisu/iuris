class CreateBasis < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, :last_name, :null => false
      # Authlogic columns
      t.timestamps
    end

    create_table :user_sessions do |t|
      t.timestamps
    end

    create_table :messages do |t|
      t.belongs_to :author
      t.belongs_to :message
      t.string :title
      t.string :name, :null => false
      t.string :body
      t.timestamps
    end

    create_table :articles do |t|
      t.belongs_to :author
      t.string :state
      t.string :title
      t.string :name, :null => false
      t.text :body
      t.timestamps
    end

    create_table :documents do |t|
      t.belongs_to :owner
      t.string :title
      # Paperclip columns
      t.timestamps
    end

    create_table :labels do |t|
      t.belongs_to :label
      t.string :name, :null => false
      t.text :description
      t.boolean :usable_with_documents
      t.boolean :usable_with_articles
      t.boolean :usable_with_messages
      t.timestamps
    end

    create_table :tags do |t|
      t.belongs_to :label
      t.belongs_to :tagged, :polymorphic => true
      t.timestamps
    end

  end

end
