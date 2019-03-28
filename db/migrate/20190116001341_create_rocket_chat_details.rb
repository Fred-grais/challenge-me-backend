class CreateRocketChatDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :rocket_chat_details do |t|
      t.string :rocketchat_id, null: false
      t.string :username, null: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
