class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer    :creator_id
      t.integer    :project_id
      t.integer    :todo_list_id
      t.integer    :assigned_user_id
      t.integer    :state
      t.date       :deadlines
      t.text       :content
      t.timestamps
    end
  end
end
