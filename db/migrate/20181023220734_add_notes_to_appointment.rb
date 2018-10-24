class AddNotesToAppointment < ActiveRecord::Migration[5.2]
  def change
  	add_column :appointments, :notes, :text
  end
end
