class Admin::DashboardsController < ApplicationController
	def show

	end

	def top_for_day
		date = Date.parse(params[:date])
		item_counts = CheckoutItem.top_items(5, date)

		respond_to do |format|
	    format.html
	    format.json { render json: item_counts }
	  end
	end

	def checkout_items_by_day
		counts_by_day = CheckoutItem.group_by_day(:created_at).sum(:count).to_a

		respond_to do |format|
	    format.html
	    format.json { render json: counts_by_day }
	  end
	end

end