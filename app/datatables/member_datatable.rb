class MemberDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      membership_id:         { source: "Membership.number" },
      first_name: { source: "Member.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "Member.last_name",  cond: :like },
      email:      { source: "Member.email" },
      phone:      { source: "Member.phone_number" },
      document_number:      { source: "Member.document_number" }
    }
  end

  def_delegators :@view, :link_to, :membership_path

  def data
    records.map do |record|
      {
        # example:
        membership_id: record.membership.number,
        first_name: link_to(record.first_name, membership_path(record.membership)),
        last_name: link_to(record.last_name, membership_path(record.membership)),
        email: record.email,
        phone: record.phone_number,
        document_number: record.document_number
      }
    end
  end

  def get_raw_records
    # insert query here
    Member.includes(:membership).references(:membership)
  end

end
