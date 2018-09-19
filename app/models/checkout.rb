class Checkout < ApplicationRecord
	has_many :checkout_items

	enum status: [:pending, :cancelled, :completed]

	accepts_nested_attributes_for :checkout_items, allow_destroy: true
end