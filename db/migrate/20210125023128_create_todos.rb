class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.integer :index
      t.string :title
      t.boolean :complete

      t.timestamps
    end
  end
  def up
    drop_table :todos
    create_table :todos do |t|
      t.integer :index
      t.string :title
      t.boolean :complete

      t.timestamps
    end
  end
end
