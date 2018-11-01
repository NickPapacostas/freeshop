class Member < ApplicationRecord
	belongs_to :membership

	validates_presence_of :first_name

	def age
		Date.today.year - birth_year unless birth_year.nil?
	end

	def full_name
		"#{first_name.capitalize} #{last_name.capitalize}"
	end
end