class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
	extend Forwardable

	def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end
end