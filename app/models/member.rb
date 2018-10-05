class Member < ApplicationRecord
	belongs_to :membership

	def full_name
		"#{first_name} #{last_name}"
	end
end