class DashboardsController < ApplicationController
	# before_action :authenticate_volunteer!

	def show
		@volunteer = current_volunteer
		@todays_appointments = Appointment.today
	end

end
