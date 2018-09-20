class AddPointOfContactToMemberships < ActiveRecord::Migration[5.2]
  def change
  	add_column :memberships, :point_of_contact_id, :integer
  end
end
