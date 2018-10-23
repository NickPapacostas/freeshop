class Member < ApplicationRecord
	belongs_to :membership

	validates_presence_of :first_name

	def age
		Date.today.year - birth_year
	end

	def full_name
		"#{first_name} #{last_name}"
	end
end