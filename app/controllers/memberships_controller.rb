class MembershipsController < ApplicationController
	def new
		@membership = Membership.new
		@membership.members.build
	end

	def create
		@membership = Membership.new(membership_params)
		@membership.number = Membership.next_membership_number
		if @membership.save
			@membership.update_attribute(:point_of_contact_id, @membership.members.first.id)
			flash.now[:success] = 'Membership created'

			redirect_to membership_path(@membership)
		else
			flash[:error] = "Failed to create membership: "
			flash[:error] += @membership.errors.full_messages.join(", ")
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
		if @membership.update_attributes(membership_params)
			@membership.update_attribute(:point_of_contact_id, @membership.members.first.id)

			flash.now[:success] = 'Membership updated'
			render 'show'
		else
			flash[:error] = 'Membership not updated'
			@membership.reload
			render 'show'
		end
	end

	def destroy
		@membership = Membership.find(params[:id])
		if @membership.destroy!
			flash.now[:success] = "membership deleted"
			redirect_to volunteer_dashboard_path(current_volunteer)
		end
	end

	private

	def membership_params
		params.require(:membership).permit(members_attributes: [:id, :_destroy, :first_name, :last_name, :birth_year,
				:phone_number, :email, :document_number, :notes])
	end
end
