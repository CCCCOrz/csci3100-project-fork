class AddPasswordConfirmationToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_confirmation, :string
  end
end
