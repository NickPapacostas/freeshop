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
		params.require(:appointment).permit(:datetime, :membership_id, :people_count)
	end
end