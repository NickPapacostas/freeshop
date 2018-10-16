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
		if @checkout.save
			@checkout.update_attribute(:status, 'completed')
			@checkout.appointment.update_attribute(:attended, true)
			render 'show'
		else
			render 'new', checkout: @checkout
		end
	end

	def show
		@checkout = Checkout.find(params[:id])
	end


	private

	def checkout_params
		params.require(:checkout).permit(:appointment_id, checkout_items_attributes: [:item_id, :count])
	end
end