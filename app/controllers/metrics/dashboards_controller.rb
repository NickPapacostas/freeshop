class Metrics::DashboardsController < ApplicationController
	def show
		set_dates
	end

	def top_for_day
		date = Date.parse(params[:date])
		item_counts = CheckoutItem.top_items(5, date.beginning_of_day, date.end_of_day)

		respond_to do |format|
	    format.html
	    format.json { render json: item_counts }
	  end
	end

	def items
		set_dates
		checkout_items = CheckoutItem.where(created_at: @start_date..@end_date)
		counts_by_day = checkout_items.group_by_day(:created_at).sum(:count).to_a
		@total = checkout_items.sum(:count)

		top_items = CheckoutItem.top_items(nil, @start_date, @end_date)

		respond_to do |format|
	    format.html
	    format.json { render json: [counts_by_day, @total, top_items] }
	  end
	end


	def appointments
		set_dates
		appointments_by_day = Appointment.where(attended: true).where(created_at: @start_date..@end_date).group_by_day(:created_at).count.to_a
		attendees_by_day = Appointment.where(attended: true).where(created_at: @start_date..@end_date).group_by_day(:created_at).sum(:people_count).to_a

		respond_to do |format|
	    format.html
	    format.json { render json: {appointments: appointments_by_day, attendees: attendees_by_day} }
	  end
	end

	private

	def set_dates
		@start_date = if params[:start_date]
			Date.parse(params[:start_date])
		else
			Date.today - 2.months
		end

		@end_date = if params[:end_date]
			Date.parse(params[:end_date])
		else
			Date.today + 1.days
		end
	end
end