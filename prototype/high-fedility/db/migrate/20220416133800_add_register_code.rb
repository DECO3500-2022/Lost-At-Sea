class AddRegisterCode < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.integer :register_code
      t.boolean :activated, default: false
    end
  end
end
