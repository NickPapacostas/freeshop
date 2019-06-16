class Metrics::DashboardsController < ApplicationController
	def show
		set_item_dates
	end

	def top_for_day
		date = Date.parse(params[:date])
		item_counts = CheckoutItem.top_items(5, date)

		respond_to do |format|
	    format.html
	    format.json { render json: item_counts }
	  end
	end

	def items
		set_item_dates
		counts_by_day = CheckoutItem.where(created_at: @start_date..@end_date).group_by_day(:created_at).sum(:count).to_a

		respond_to do |format|
	    format.html
	    format.json { render json: counts_by_day }
	  end
	end


	def appointments
		appointments_by_day = Appointment.where(attended: true).where('created_at > ?', Date.new(2018, 11, 3)).group_by_day(:created_at).count.to_a
		attendees_by_day = Appointment.where(attended: true).where('created_at > ?', Date.new(2018, 11, 3)).group_by_day(:created_at).sum(:people_count).to_a

		respond_to do |format|
	    format.html
	    format.json { render json: {appointments: appointments_by_day, attendees: attendees_by_day} }
	  end
	end

	private

	def set_item_dates
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