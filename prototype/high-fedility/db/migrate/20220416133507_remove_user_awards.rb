class RemoveUserAwards < ActiveRecord::Migration[7.0]
  def change
    def change
      change_table :users do |t|
        t.remove :gold_coin, :trophy
      end
    end
  end
end
