class CreateAwards < ActiveRecord::Migration[7.0]
  def change
    create_table :awards do |t|
      t.references :user
      t.references :backer
      t.belongs_to :post, foreign_key: true, null: true
      t.belongs_to :comment, foreign_key: true, null: true
      t.integer :award_type, :default => 0
      t.timestamps
    end
  end
end
