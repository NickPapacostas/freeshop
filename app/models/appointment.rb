class Appointment < ApplicationRecord
	has_one :membership
	has_one :checkout

	def self.today
		where(datetime: Date.today.all_day)
	end

	def attended?
		attended
	end

end