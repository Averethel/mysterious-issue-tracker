class AddCreatorToComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.references :creator, references: :users, null: false
    end

    add_foreign_key :comments, :users, column: :creator_id
  end
end
