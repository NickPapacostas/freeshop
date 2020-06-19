class Timeslot
	attr_accessor :datetime, :max_people

	def initialize(datetime, appointments = [])
		@datetime = datetime
		@max_people = 10
		unless appointments.empty?
			@appointments = appointments
				.select { |a| a.datetime == datetime}
		end
	end

	def appointments
		# ensure membership exists
		@appointments ||= Appointment.joins(:membership).where(datetime: datetime)
	end

	def people_count
		appointments.map(&:people_count).compact.sum
	end

	def full?
		people_count >= max_people
	end

	def for_month
		people_count = people_count()
		remaining = max_people - people_count

		{
			datetime: datetime,
			full: full?,
			remaining: remaining,
			people_count: people_count
		}
	end

	def for_today
		{
			datetime: datetime,
			full: full?,
			people_count: people_count,
			appointments: appointments.map(&:for_today)
		}
	end
end