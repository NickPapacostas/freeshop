class Timeslot
	attr_accessor :datetime, :max_people

	def initialize(datetime)
		@datetime = datetime
		@max_people = 10
	end

	def appointments
		Appointment.where(datetime: datetime)
	end

	def people_count
		appointments.map(&:people_count).sum
	end

	def full?
		people_count >= max_people
	end

	def to_h
		{
			datetime: datetime,
			full: full?,
			people_count: people_count
		}
	end
end