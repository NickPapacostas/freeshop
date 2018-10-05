class AddAppointmentToCheckouts < ActiveRecord::Migration[5.2]
  def change
  	add_column :checkouts, :appointment_id, :integer, null: false
  end
end
