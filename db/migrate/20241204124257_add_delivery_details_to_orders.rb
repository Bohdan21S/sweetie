class AddDeliveryDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :pickup_location, :string
    add_column :orders, :nova_poshta_branch, :string
  end
end
