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

  def self.top_items(number = 10, date = nil)
    if date
      relation = CheckoutItem.where(created_at: date.beginning_of_day..date.end_of_day)
    else
      relation = CheckoutItem
    end

		top_items_and_counts = relation.group(:item_id).sum(:count).sort_by {|item_id, count| -count }.first(number)
		top_items_and_counts.map do |item_id_and_count|
			item_id, count = item_id_and_count
			[Item.find(item_id).display_name, count]
		end
  end
end


