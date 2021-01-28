class CreatePharmacyStoreMasks < ActiveRecord::Migration[6.0]
  def change
    create_table :pharmacy_store_masks do |t|
      t.integer :pharmacy_store_id
      t.string :pharmacy_mask_name
      t.float :pharmacy_mask_price
      t.timestamps
    end
  end
end
