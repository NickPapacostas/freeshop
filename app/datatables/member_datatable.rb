class MemberDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id:         { source: "Member.id" },
      first_name: { source: "Member.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "Member.last_name",  cond: :like },
      email:      { source: "Member.email" },
      phone:      { source: "Member.phone" },
      document_number:      { source: "Member.document_number" }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        first_name: record.first_name,
        last_name: record.last_name,
        email: record.email,
        phone: record.phone_number,
        document_number: record.document_number
      }
    end
  end

  def get_raw_records
    # insert query here
    Member.all
  end

end
