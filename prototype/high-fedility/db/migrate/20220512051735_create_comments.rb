class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :post, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :commentable_id
      t.string :commentable_type
      t.string :ancestry
      t.timestamps
    end

    add_index :comments, :ancestry
  end
end
