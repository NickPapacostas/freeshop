class Checkout < ApplicationRecord

	has_many :checkout_items
	belongs_to :appointment
	has_one :membership, through: :appointment

	enum status: [:incomplete, :cancelled, :completed]

	accepts_nested_attributes_for :checkout_items, allow_destroy: true
end