class CreateCheckoutItems < ActiveRecord::Migration[5.2]
  def change
    create_table :checkout_items do |t|
    	t.references :item, null: false
    	t.integer :count, null: false
    	t.timestamps
    end
  end
end
