class Appointment < ApplicationRecord
	belongs_to :membership
	has_one :checkout

	validates_presence_of :datetime

	# after_create :create_checkout

	@@appointment_length = 30.minutes

	def self.today
		self.for_day
	end

	def self.for_day(date = Date.today)
		timeslots_for_day(date).map(&:for_today)
	end

	def self.this_month
		where(datetime: Date.today.beginning_of_month..Date.today.end_of_month)
	end

	def self.for_month(month = Date.today.month, year = Time.current.year)
		appointments = self.this_month
		timeslots = []
		first_day = Date.new(year, month)
		Time.days_in_month(month).times do |day_in_month|
			timeslots << timeslots_for_day(first_day + day_in_month.days, appointments).map(&:for_month)
		end
		timeslots.flatten
	end

	def self.available_appointments(start_date = Date.today, end_date = Date.today + 7.days)
		(Date.today..(Date.today + 7.days)).to_a.flat_map do |day|
			appointments_for_day(day)
		end
	end

	def self.timeslots_for_day(date = Date.today, appointments = nil, appointment_length = @@appointment_length)
		# could use sql query  appointment group by datetime for timeslots
		appointments ||= where(datetime: date.beginning_of_day..date.end_of_day)
		timeslots = []
		start_time = date.to_time + 11.hours
		timeslots << Timeslot.new(start_time)
		next_timeslot =  start_time + appointment_length
		while next_timeslot < date.to_time + 16.hours
			timeslots << Timeslot.new(next_timeslot, appointments)
			next_timeslot += appointment_length
		end
		timeslots
	end

	def attended?
		attended
	end

	def display_datetime
		datetime.localtime.strftime("%B %d, %A %H:%M")
	end

	def start_time
		datetime
	end

	#should be in serializers
	def for_today
		if checkout && checkout.status == 'completed'
			checkout_link = nil
			destroy_link = nil
		else
			checkout_link = Rails.application.routes.url_helpers.new_checkout_path(appointment_id: id)
			destroy_link = Rails.application.routes.url_helpers.appointment_path(id)
		end

		show_link = Rails.application.routes.url_helpers.appointment_path(id)

		{
			name: membership.name,
			people_count: people_count,
			checkout_link: checkout_link,
			destroy_link: destroy_link,
			show_link: show_link
		}
	end

	# dev helpers

	def self.generate_full_slot(datetime = Appointment.timeslots_for_day(Date.today).first.datetime)
		Appointment.create(datetime: datetime, people_count: 10, membership_id: Membership.first.id)
		Timeslot.new(datetime)
	end
end