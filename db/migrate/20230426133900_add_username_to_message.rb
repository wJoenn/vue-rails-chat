class AddUsernameToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :username, :string
  end
end
