class CreateProjectKpis < ActiveRecord::Migration[5.2]
  def change
    create_table :project_kpis do |t|

      t.belongs_to :project, index: {unique: true}, foreign_key: true

      t.timestamps
    end
  end
end
