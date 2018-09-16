class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
    	t.boolean :attended, default: false, null: false
 			t.timestamps
    end
  end
end
