class AddAssigneeToIssue < ActiveRecord::Migration
  def change
    change_table :issues do |t|
      t.references :assignee, references: :users
    end

    add_foreign_key :issues, :users, column: :assignee_id
  end
end
