class CreatePharmacies < ActiveRecord::Migration[6.0]
  def change
    create_table :pharmacies do |t|
      t.string :name
      t.float :cash_balance
      t.timestamps
    end
  end
end
