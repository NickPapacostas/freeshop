class AddTypeAndSizeToItem < ActiveRecord::Migration[5.2]
  def change
  	add_column :items, :size_id, :integer, null: false
  	add_column :items, :item_type_id, :integer, null: false
  end
end
