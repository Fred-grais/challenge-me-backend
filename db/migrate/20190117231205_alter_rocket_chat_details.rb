class AlterRocketChatDetails < ActiveRecord::Migration[5.2]
  def change
    rename_column :rocket_chat_details, :username, :name
    add_column :rocket_chat_details, :rocketable_type, :string, null: false
    add_column :rocket_chat_details, :rocketable_id, :integer, null: false
    remove_column :rocket_chat_details, :user_id

    add_index :rocket_chat_details, [:rocketable_id, :rocketable_type], unique: true
  end
end
