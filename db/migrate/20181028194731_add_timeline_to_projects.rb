class AddTimelineToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :timeline, :json, default: {items: []}
  end
end
