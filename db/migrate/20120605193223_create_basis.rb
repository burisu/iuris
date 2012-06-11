class CreateBasis < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string   :name, :null => false
      t.string   :nature, :null => false
      t.string     :document_value_file_name
      t.integer    :document_value_file_size
      t.string     :document_value_content_type
      t.datetime   :document_value_updated_at
      t.string     :document_value_fingerprint
      t.string     :string_value
      t.boolean    :boolean_value
      t.decimal    :decimal_value
      t.date       :date_value
      t.datetime   :datetime_value
      t.belongs_to :record_value, :polymorphic => true
      t.timestamps
    end
    add_index :parameters, :name
    add_index :parameters, :nature

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
      t.string :type
      t.string :name, :null => false
      t.text :content
      t.timestamps
    end
    add_index :messages, :author_id
    add_index :messages, [:origin_id, :origin_type]

    # create_table :articles do |t|
    #   t.belongs_to :author
    #   t.string :state
    #   t.string :name, :null => false
    #   t.text :content
    #   t.timestamps
    # end
    # add_index :articles, :author_id
    # add_index :articles, :state

    create_table :publication_natures do |t|
      t.string :name, :null => false
      t.string :title_format, :null => false
      t.boolean :need_title,     :null => false, :default => false
      t.boolean :need_source,    :null => false, :default => false
      t.boolean :need_reference, :null => false, :default => false
      t.boolean :need_date,      :null => false, :default => false
      t.timestamps
    end

    create_table :publications do |t|
      t.belongs_to :author
      t.belongs_to :nature
      t.text :name, :null => false
      t.string :description
      # Meta-data
      t.string :name_title
      t.string :name_source
      t.string :name_reference
      t.date   :name_date
      # Document
      t.string :origin, :null => false
      t.text   :url
      t.string :state
      t.string   :document_file_name
      t.integer  :document_file_size
      t.string   :document_content_type
      t.datetime :document_updated_at
      t.string   :document_fingerprint
      t.timestamps
    end
    add_index :publications, :author_id
    add_index :publications, :nature_id
    add_index :publications, :origin
    add_index :publications, :name
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
      t.boolean :usable_with_questions
      # t.boolean :usable_with_articles
      t.boolean :usable_with_publications
      t.boolean :usable_with_templates
      t.timestamps
    end
    add_index :labels, :name
    add_index :labels, :usable_with_questions
    # add_index :labels, :usable_with_articles
    add_index :labels, :usable_with_publications
    add_index :labels, :usable_with_templates

  end

end
