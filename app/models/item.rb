class Item < ApplicationRecord
	belongs_to :item_type
	belongs_to :size

	validates :item_type_id, uniqueness: {scope: :size_id}

	def display_name
		"#{item_type.name} -- #{size.name}"
	end
end

