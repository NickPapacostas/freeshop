class Checkout < ApplicationRecord
	has_many :items
	has_one :checkout

	enum status: [:pending, :cancelled, :completed]
end