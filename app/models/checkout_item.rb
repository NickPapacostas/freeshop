class CheckoutItem < ApplicationRecord
 	belongs_to :item

 	def self.create_from_params(checkout_item_params)
 	end
end

