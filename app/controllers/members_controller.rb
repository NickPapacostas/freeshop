class MembersController < ApplicationController
	def index
		@members = Member.all
	  respond_to do |format|
	    format.html
	    format.json { render json: MemberDatatable.new(params) }
	  end
	end
end
