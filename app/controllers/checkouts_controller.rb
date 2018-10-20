class CheckoutsController < ApplicationController
	def new
		@appointment = Appointment.find(params[:appointment_id])
		@checkout = Checkout.new(appointment_id: params[:appointment_id])
		@checkout.checkout_items.build
		@items = Item.all
	end

	def create
		@checkout = Checkout.new(checkout_params)
		@checkout.checkout_items.select {|c_item| c_item.count.nil? }.map(&:destroy)

		# check for duplicate items
		if @checkout.checkout_items.uniq {|ci| ci.item_id }.length != @checkout.checkout_items.length
			flash.now[:error] = "Failed to create checkout: item types must be unique"
			@appointment = @checkout.appointment
			@items = Item.all

			render 'new'
		else
			if @checkout.save
				@checkout.update_attribute(:status, 'completed')
				@checkout.appointment.update_attribute(:attended, true)
				render 'show'
			else
				render 'new', checkout: @checkout
			end
		end
	end

	def show
		@checkout = Checkout.find(params[:id])
	end


	private

	def checkout_params
		params.require(:checkout).permit(:appointment_id, checkout_items_attributes: [:_destroy, :item_id, :count])
	end
end