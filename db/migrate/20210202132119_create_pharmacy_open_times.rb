class CreatePharmacyOpenTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :pharmacy_open_times do |t|
      t.integer :pharmacy_id
      t.string :week
      t.time :open_time
      t.time :close_time
      t.timestamps
    end
  end
end
