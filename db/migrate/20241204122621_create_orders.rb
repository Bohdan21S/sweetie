class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price
      t.string :delivery_method
      t.string :delivery_location
      t.string :payment_method
      t.string :status

      t.timestamps
    end
  end
end
