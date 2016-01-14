class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer    :user_id
      t.integer    :source_id
      t.string     :source_type
      t.integer    :resource_id
      t.string     :resource_type
      t.string     :action
      t.integer    :old_assigned_user_id
      t.integer    :new_assigned_user_id
      t.date       :old_deadlines
      t.date       :new_deadlines

      t.timestamps
    end
  end
end
