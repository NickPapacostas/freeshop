class Member < ApplicationRecord
	belongs_to :membership, dependent: :destroy

	def age
		Date.today.year - birth_year
	end

	def full_name
		"#{first_name} #{last_name}"
	end
end