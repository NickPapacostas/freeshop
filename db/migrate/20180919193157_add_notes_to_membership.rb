class AddNotesToMembership < ActiveRecord::Migration[5.2]
  def change
  	add_column :memberships, :notes, :text
  end
end
