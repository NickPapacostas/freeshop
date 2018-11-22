class Checkout < ApplicationRecord

	has_many :checkout_items
	belongs_to :appointment
	has_one :membership, through: :appointment

	enum status: [:incomplete, :cancelled, :completed]

	accepts_nested_attributes_for :checkout_items, allow_destroy: true


	def item_totals
		checkout_items.reduce({}) do |total_hash, checkout_item|
			key = checkout_item.item.display_name
			total_hash[key] = checkout_item.count
			total_hash
		end
	end
end