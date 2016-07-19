class AddUserDeactivation < ActiveRecord::Migration
  def up
    add_column :users, :deactivated_at, :datetime
  end

  def down
    remove_column :users, :deactivated_at
  end
end
