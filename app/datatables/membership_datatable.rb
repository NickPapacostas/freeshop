class MembershipDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      number:         { source: "Membership.number" },
      first_name: { source: "Member.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "Member.last_name",  cond: :like },
      email:      { source: "Member.email" }
    }
  end


  def_delegators :@view, :link_to,:membership_path, :content_tag

  def data
    records.map do |record|
      first_name = record.point_of_contact.try(:first_name)
      last_name = record.point_of_contact.try(:last_name)

      number = content_tag(:div,
        record.number,
        {
          class: "membership-id",
          "data-id" => record.id,
          "data-number" => record.number,
          "data-name" => record.point_of_contact.try(:full_name)
        })

      if !params[:modal]
        first_name = link_to(first_name, membership_path(record))
        last_name = link_to(last_name, membership_path(record))
      end


      {
        # example:
        number: number,
        first_name: first_name,
        last_name: last_name,
        email: record.try(:point_of_contact).try(:email)
      }
    end
  end

  def get_raw_records
    # insert query here
    Membership.all.includes(:members).references(:members) #.includes(:point_of_contact)
  end

end
