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

	def items
		counts_by_day = CheckoutItem.group_by_day(:created_at).sum(:count).to_a

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


end