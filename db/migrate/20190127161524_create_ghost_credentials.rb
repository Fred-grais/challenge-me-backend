class CreateGhostCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :ghost_credentials do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
