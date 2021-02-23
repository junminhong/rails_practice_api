class CreateUserPurchaseHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_purchase_histories do |t|
      t.integer :user_id
      t.string :pharmacy_name
      t.string :mask_name
      t.float :transaction_amount
      t.datetime :transaction_date
      t.timestamps
    end
  end
end
