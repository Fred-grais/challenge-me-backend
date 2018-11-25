class CreatePodcasts < ActiveRecord::Migration[5.2]
  def change
    create_table :podcasts do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :categories, array: true, default: []
      t.string :duration, null: false
      t.datetime :publishing_date, null: false
      t.string :thumbnail_url
      t.string :content_url, null: false
      t.string :original_link

      t.timestamps
    end

    add_index :podcasts, :title, unique: true
  end
end
