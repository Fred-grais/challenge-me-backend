class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :conversation_id, null: false
      t.integer :sender_id, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_foreign_key :messages, :conversations
    add_foreign_key :messages, :users, {column: :sender_id}
  end
end
