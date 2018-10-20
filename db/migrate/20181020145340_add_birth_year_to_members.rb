class AddBirthYearToMembers < ActiveRecord::Migration[5.2]
  def change
  	add_column :members, :birth_year, :integer
  end
end
