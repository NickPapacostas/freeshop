class MembershipsController < ApplicationController
	def new
		@membership = Membership.new
		@membership.members.build
	end

	def create
		@membership = Membership.new(membership_params)
		if @membership.save && @membership.members.map(&:save)
			render 'show'
		else
			render 'new'
		end
	end

	def index
		@memberships = Membership.all
	  respond_to do |format|
	    format.html
	    format.json { render json: MembershipDatatable.new(params, view_context: view_context) }
	  end
	end

	private

	def membership_params
		params.require(:membership).permit(members_attributes: [:first_name, :last_name,
				:phone_number, :email, :document_number, :notes])
	end
end
