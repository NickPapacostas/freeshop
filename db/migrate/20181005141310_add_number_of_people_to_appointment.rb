class AddNumberOfPeopleToAppointment < ActiveRecord::Migration[5.2]
  def change
  	add_column :appointments, :people_count, :integer, default: 1, null: false
  end
end
