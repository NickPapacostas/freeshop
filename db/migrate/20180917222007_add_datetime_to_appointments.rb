class AddDatetimeToAppointments < ActiveRecord::Migration[5.2]
  def change
  	add_column :appointments, :datetime, :timestamp, null: false
  end
end
