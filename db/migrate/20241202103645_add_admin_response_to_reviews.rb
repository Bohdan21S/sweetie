class AddAdminResponseToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :admin_response, :text
  end
end
