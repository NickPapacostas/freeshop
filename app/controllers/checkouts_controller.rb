class CheckoutsController < ApplicationController
	def new
		@appointment = Appointment.find(params[:appointment_id])
		@checkout = Checkout.new(appointment_id: params[:appointment_id])

		CheckoutItem.build_default_items.each do |checkout_item|
			@checkout.checkout_items.build(item: checkout_item.item, count: 1)
		end

		@checkout.checkout_items.build

		@items = Item.all
	end

	def edit
		@checkout = Checkout.find(params[:id])
		@appointment = @checkout.appointment
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
				flash.now[:success] = "Checkout completed"
				render 'show'
			else
				render 'new', checkout: @checkout
			end
		end
	end

	def update
		@checkout = Checkout.find(params[:id])
		@checkout.update_attributes(checkout_params)

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
				flash.now[:success] = "Checkout completed"
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
		params.require(:checkout).permit(:id, :appointment_id, checkout_items_attributes: [:id, :_destroy, :item_id, :count])
	end
end