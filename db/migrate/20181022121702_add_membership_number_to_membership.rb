class AddMembershipNumberToMembership < ActiveRecord::Migration[5.2]
  def change
  	add_column :memberships, :number, :integer
  end
end
