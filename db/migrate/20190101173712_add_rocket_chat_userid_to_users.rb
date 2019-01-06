class AddRocketChatUseridToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rocket_chat_user_id, :string
  end
end
