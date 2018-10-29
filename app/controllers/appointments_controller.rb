class AppointmentsController < ApplicationController
	def new
		@appointment = Appointment.new
	end

	def create
		@appointment = Appointment.new(appointment_params)

		# so that the form can still be generated with "membership_id"
		@appointment.membership_id = Membership.find_by(number: appointment_params[:membership_id]).id

		if @appointment.save
			flash[:success] = 'created appointment'
			@appointment = Appointment.new
			redirect_to new_appointment_path
		else
			flash.now[:error] = 'didnt save appointment'
			redirect_to new_appointment_path
		end
	end

	def destroy
		@appointment = Appointment.find(params[:id])
		if @appointment.destroy!
			flash.now[:success] = "appointment cancelled"
			redirect_to new_appointment_path
		end
	end

	def show
		@appointment = Appointment.find(params[:id])
	end

	def update
		@appointment = Appointment.find(params[:id])
		if @appointment.update!(appointment_params)
			flash.now[:success] = "appointment updated"
			render 'show'
		else
			flash.now[:error] = "appointment not updated: #{@appointment.errors.map(&:message).join(", ")}"
			render 'show'
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
		params.require(:appointment).permit(:datetime, :membership_id, :people_count, :notes)
	end
end