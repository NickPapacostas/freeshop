class AppointmentsController < ApplicationController
	def new
		@appointment = Appointment.new
	end

	def create
		@appointment = Appointment.new(appointment_params)

		if @appointment.save
			@appointment = Appointment.new
			render 'new'
		else
			flash[:error] = 'didnt save appointment'
			redirect_to 'new'
		end
	end

	def index
		@timeslots = params[:d] ? Appointment.for_month(params[:d]) : Appointment.for_month

		respond_to do |format|
	    format.html
	    format.json { render json: @timeslots }
	  end

	end

	def by_month
		@appointments = Appointment.for_month(params[:month].to_i, params[:year].to_i)

		respond_to do |format|
	    format.html
	    format.json { render json: @appointments }
	  end

	end

	def by_day
		@timeslots = Appointment.for_day(Date.parse(params[:date]))

		respond_to do |format|
	    format.html
	    format.json { render json: @timeslots }
	  end
	end

	def by_datetime
		@timeslots = Appointment.where(datetime: Time.iso8601(params[:datetime]))
		@timeslots = @timeslots.map(&:for_today)

		respond_to do |format|
	    format.html
	    format.json { render json: @timeslots }
	  end
	end

	private

	def appointment_params
		params.require(:appointment).permit(:datetime, :membership_id, :people_count)
	end
end