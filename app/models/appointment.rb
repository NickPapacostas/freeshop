class Appointment < ApplicationRecord
	has_one :membership
	has_one :checkout

	validates_presence_of :datetime

	@@appointment_length = 30.minutes

	def self.today
		where(datetime: Date.today.all_day)
	end

	def self.available_appointments(start_date = Date.today, end_date = Date.today + 7.days)
		(Date.today..(Date.today + 7.days)).to_a.flat_map do |day|
			appointments_for_day(day)
		end
	end


	def self.appointments_for_day(date, appointment_length = @@appointment_length)
		appointments = []
		start_time = date.to_time + 9.hours + appointment_length
		appointments << start_time
		next_appointment =  start_time + appointment_length
		while next_appointment < date.to_time + 17.hours
			appointments << next_appointment
			next_appointment += appointment_length
		end
		appointments
	end

	def attended?
		attended
	end

	def start_time
		datetime
	end

end