class Appointment < ApplicationRecord
	belongs_to :membership
	has_one :checkout

	validates_presence_of :datetime

	@@appointment_length = 30.minutes

	def self.today
		timeslots_for_day.map(&:for_today)
	end

	def self.this_month
		where(datetime: Date.today.beginning_of_month..Date.today.end_of_month)
	end

	def self.for_month(month = Date.today.month)
		timeslots = []
		Time.days_in_month(month).times do |day_in_month|
			timeslots << timeslots_for_day(Date.today.beginning_of_month + day_in_month.days).map(&:for_month)
		end
		timeslots.flatten
	end

	def self.available_appointments(start_date = Date.today, end_date = Date.today + 7.days)
		(Date.today..(Date.today + 7.days)).to_a.flat_map do |day|
			appointments_for_day(day)
		end
	end

	def self.timeslots_for_day(date = Date.today, appointment_length = @@appointment_length)
		timeslots = []
		start_time = date.to_time + 9.hours + appointment_length
		timeslots << Timeslot.new(start_time)
		next_timeslot =  start_time + appointment_length
		while next_timeslot < date.to_time + 17.hours
			timeslots << Timeslot.new(next_timeslot)
			next_timeslot += appointment_length
		end
		timeslots
	end

	def attended?
		attended
	end

	def start_time
		datetime
	end

	def for_today
		{
			name: membership.name,
			people_count: people_count
		}
	end

	# dev helpers

	def self.generate_full_slot(datetime = Appointment.timeslots_for_day(Date.today).first.datetime)
		Appointment.create(datetime: datetime, people_count: 10, membership_id: Membership.first.id)
		Timeslot.new(datetime)
	end
end