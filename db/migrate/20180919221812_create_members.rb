class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
    	t.references :membership, null: false
    	t.string :first_name
    	t.string :last_name
    	t.string :phone_number
    	t.string :email
    	t.string :document_number
    	t.text 	 :notes
    	t.timestamps
    end
  end
end
