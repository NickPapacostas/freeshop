class MemberDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      membership_id:         { source: "Membership.number" },
      first_name: { source: "Member.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "Member.last_name",  cond: :like },
      email:      { source: "Member.email" },
      phone:      { source: "Member.phone_number" },
      birth_year:      { source: "Member.birth_year" }
    }
  end

  def_delegators :@view, :link_to, :membership_path

  def data
    records.map do |record|
      {
        # example:
        membership_id: link_to(record.membership.number, membership_path(record.membership)),
        first_name: link_to(record.first_name, membership_path(record.membership)),
        last_name: link_to(record.last_name, membership_path(record.membership)),
        birth_year: record.birth_year,
        email: record.email,
        phone: record.phone_number
      }
    end
  end

  def get_raw_records
    # insert query here
    Member.includes(:membership).references(:membership)
  end

end
