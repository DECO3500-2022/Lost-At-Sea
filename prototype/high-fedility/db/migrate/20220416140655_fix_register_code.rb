class FixRegisterCode < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.remove :register_code
      t.string :register_code, default: ''
    end
  end
end
