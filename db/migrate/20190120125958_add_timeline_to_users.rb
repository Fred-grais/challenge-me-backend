class AddTimelineToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :timeline, :json, default: {items: []}
  end
end
