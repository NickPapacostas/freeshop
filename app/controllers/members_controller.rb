class MembersController < ApplicationController
	def index
		@members = Member.all
	  respond_to do |format|
	    format.html
	    format.json { render json: MemberDatatable.new(params, view_context: view_context) }
	  end
	end

	def edit
		@member = Member.find(params[:id])
	end

	def show
		@member = Member.find(params[:id])
	end

	def search
		query = params[:q]
		@results = Member.search(query)

	  respond_to do |format|
	    format.html
	    format.json { render json: @results }
	  end

	end
end
