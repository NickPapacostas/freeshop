class ApplicationController < ActionController::Base

	def after_sign_in_path_for(volunteer)
  	volunteer_dashboard_path(volunteer)
	end

	def after_sign_out_path_for(volunteer)
	  new_session_path
	end
end
