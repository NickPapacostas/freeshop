class ApplicationController < ActionController::Base
	before_action :authenticate_volunteer!


	def after_sign_in_path_for(volunteer)
  	volunteer_dashboard_path(volunteer)
	end

	def after_sign_out_path_for(volunteer)
	  new_session_path(volunteer)
	end
end
