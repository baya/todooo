class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer    :creator_id
      t.integer    :team_id
      t.string     :name
      t.timestamps
    end
  end
end
