class AddCheckoutToCheckoutItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :checkout_items, :checkout_id, :integer
  end
end
