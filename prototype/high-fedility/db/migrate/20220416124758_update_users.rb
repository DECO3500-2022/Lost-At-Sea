class UpdateUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.remove :role, :gold_coin, :trophy
      t.integer :role, default: 0
      t.integer :gold_coin, default: 0
      t.integer :trophy, default: 0
    end
  end
end
