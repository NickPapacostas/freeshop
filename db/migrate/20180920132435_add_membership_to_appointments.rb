class AddMembershipToAppointments < ActiveRecord::Migration[5.2]
  def change
  	add_column :appointments, :membership_id, :integer
  end
end
