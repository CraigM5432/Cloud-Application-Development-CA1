class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :priority
      t.datetime :due_date
      t.boolean :completed

      t.timestamps
    end
  end
end
