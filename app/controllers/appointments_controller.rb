class AppointmentsController < ApplicationController
	def new
		@appointment = Appointment.new
	end

	def create
		@appoint = Appointment.new(appointment_params)

		if @appointment.save
			render 'show'
		else
			render 'new'
		end
	end

	def index
		@timeslots = Appointment.for_calendar

		respond_to do |format|
	    format.html
	    format.json { render json: @timeslots }
	  end

	end

	private

	def appointment_params
		params.require(:appointment).permit(:datetime)
	end
end