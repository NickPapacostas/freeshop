class MembershipsController < ApplicationController
	def new
		@membership = Membership.new
		@membership.members.build
	end

	def create
		@membership = Membership.new(membership_params)
		if @membership.save && @membership.members.map(&:save)
			@membership.point_of_contact = @membership.members.first
			@membership.save
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

	def show
		@membership = Membership.find(params[:id])
	end

	def update
		@membership = Membership.find(params[:id])
		if @membership.update(membership_params)
			flash[:success] = 'Membership updated'
			render 'show'
		else
			flash[:error] = 'Membership not updated'
			render 'show'
		end

	end

	private

	def membership_params
		params.require(:membership).permit(members_attributes: [:id, :_destroy, :first_name, :last_name,
				:phone_number, :email, :document_number, :notes])
	end
end
