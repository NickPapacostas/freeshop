class CheckoutItem < ApplicationRecord
 	belongs_to :item

	def self.build_default_items
    [
      ["Toiletries", "Soap"],
      ["Toiletries", "Shampoo"]
    ].map do |type_and_size|
      item = Item.find_by(item_type: ItemType.find_by(name: type_and_size[0]), size: Size.find_by(name: type_and_size[1]))
      CheckoutItem.new(item: item, count: 1)
    end
end

