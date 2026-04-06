class FixUsersPasswordDigest < ActiveRecord::Migration[8.1]
  def up
    rename_column :users, :password, :password_digest if column_exists?(:users, :password)
    remove_column :users, :password_confirmation, :string if column_exists?(:users, :password_confirmation)
  end

  def down
    add_column :users, :password_confirmation, :string unless column_exists?(:users, :password_confirmation)
    rename_column :users, :password_digest, :password if column_exists?(:users, :password_digest)
  end
end
