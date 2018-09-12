class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :projects, :user_id
    add_index :projects, [:user_id, :name], unique: true

    add_foreign_key :projects, :users
  end
end
