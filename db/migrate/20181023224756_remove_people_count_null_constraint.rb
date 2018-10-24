class RemovePeopleCountNullConstraint < ActiveRecord::Migration[5.2]
  def change
  	change_column :appointments, :people_count, :integer, null: true
  end
end
