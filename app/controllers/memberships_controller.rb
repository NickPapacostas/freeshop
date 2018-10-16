class MembershipsController < ApplicationController
	def new
		@membership = Membership.new
		@membership.members.build
	end

	def create
		@membership = Membership.new(membership_params)
		if @membership.save && @membership.members.map(&:save)
			@membership.update_attribute(:point_of_contact, @membership.members.first)
			redirect_to membership_path(@membership)
		else
			redirect_to new_membership_path
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
			@membership.update_attribute(:point_of_contact_id, @membership.members.first.id)

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
