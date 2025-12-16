class AddRemindedAtToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :reminded_at, :datetime
  end
end
