class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :user_id
      t.integer :project_id
      t.string  :role

      t.timestamps
    end
  end
end
