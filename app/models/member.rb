class Member < ApplicationRecord
	belongs_to :membership, dependent: :destroy

	validates_presence_of :first_name, :last_name

	def age
		Date.today.year - birth_year
	end

	def full_name
		"#{first_name} #{last_name}"
	end
end