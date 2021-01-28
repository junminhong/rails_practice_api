class CreatePharmacyStores < ActiveRecord::Migration[6.0]
  def change
    create_table :pharmacy_stores do |t|
      t.string :name
      t.float :cash_balance
      t.timestamps
    end
  end
end
