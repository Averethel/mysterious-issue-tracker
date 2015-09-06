class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :priority, null: false
      t.integer :status, default: 0, null: false

      t.timestamps null: false
    end
    add_index :issues, :priority
    add_index :issues, :status
  end
end
