class AddStatusToCheckout < ActiveRecord::Migration[5.2]
  def change
  	add_column :checkouts, :status, :integer, default: 0
  end
end
