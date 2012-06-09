class CreateBasis < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string   :logo_file_name
      t.integer  :logo_file_size
      t.string   :logo_content_type
      t.datetime :logo_updated_at
      t.string :slogan
      t.text :styles
      t.text :description
      t.text :key_words
      t.timestamps
    end

    create_table(:users) do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.boolean :administrator, :null => false, :default => false
      # Biopic
      t.string :post
      t.string :address
      t.string :phone
      t.string :public_email
      t.text :skills

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token
      t.timestamps
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true

    create_table :messages do |t|
      t.belongs_to :author
      t.belongs_to :origin, :polymorphic => true
      t.boolean :question
      t.string :name, :null => false
      t.string :body
      t.timestamps
    end
    add_index :messages, :author_id
    add_index :messages, [:origin_id, :origin_type]

    # create_table :articles do |t|
    #   t.belongs_to :author
    #   t.string :state
    #   t.string :name, :null => false
    #   t.text :body
    #   t.timestamps
    # end
    # add_index :articles, :author_id
    # add_index :articles, :state

    create_table :publications do |t|
      t.belongs_to :author
      t.string :name, :null => false
      t.string :description
      t.string :nature, :null => false
      t.text   :url
      t.string :state
      t.string   :document_file_name
      t.integer  :document_file_size
      t.string   :document_content_type
      t.datetime :document_updated_at
      t.timestamps
    end
    add_index :publications, :author_id
    add_index :publications, :nature
    add_index :publications, :state

    create_table :templates do |t|
      t.belongs_to :author
      t.string :name, :null => false
      t.string :state
      t.text :content
      t.integer :uses_count, :null => false, :default => 0
      t.timestamps
    end
    add_index :templates, :author_id
    add_index :templates, :state

    create_table :tags do |t|
      t.belongs_to :label
      t.belongs_to :tagged, :polymorphic => true
      t.timestamps
    end
    add_index :tags, :label_id
    add_index :tags, [:tagged_id, :tagged_type]

    create_table :labels do |t|
      t.string :name, :null => false
      t.text :description
      t.boolean :usable_with_messages
      # t.boolean :usable_with_articles
      t.boolean :usable_with_publications
      t.boolean :usable_with_templates
      t.timestamps
    end
    add_index :labels, :name
    add_index :labels, :usable_with_messages
    # add_index :labels, :usable_with_articles
    add_index :labels, :usable_with_publications
    add_index :labels, :usable_with_templates

  end

end
