class MembershipDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      id:         { source: "Membership.id" },
      first_name: { source: "Member.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "Member.last_name",  cond: :like },
      email:      { source: "Member.email" }
  }
  end


  def_delegators :@view, :link_to

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        first_name: record.point_of_contact.try(:first_name),
        last_name: record.point_of_contact.try(:last_name),
        email: record.point_of_contact.email
      }
    end
  end

  def get_raw_records
    # insert query here
    Membership.all.includes(:members).references(:members) #.includes(:point_of_contact)
  end

end
