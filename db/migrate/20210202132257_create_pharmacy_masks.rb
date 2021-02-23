class CreatePharmacyMasks < ActiveRecord::Migration[6.0]
  def change
    create_table :pharmacy_masks do |t|
      t.integer :pharmacy_id
      t.string :name
      t.float :price
      t.timestamps
    end
  end
end
