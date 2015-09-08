class AddCreatorToIssues < ActiveRecord::Migration
  def change
    change_table :issues do |t|
      t.references :creator, references: :users, null: false
    end

    add_foreign_key :issues, :users, column: :creator_id
  end
end
