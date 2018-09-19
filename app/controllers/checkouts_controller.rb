class CheckoutsController < ApplicationController
	def new
		@checkout = Checkout.new
		@checkout.checkout_items.build
		@items = Item.all
	end

	def create
		@checkout = Checkout.new(checkout_params)

		if @checkout.save && @checkout.checkout_items.map(&:save!)
			@checkout.status = "completed"
			render 'show'
		else
			render 'new', checkout: @checkout
		end
	end


	private

	def checkout_params
		params.require(:checkout).permit(checkout_items_attributes: [:item_id, :count])
	end
end