require 'rake'
require 'spreadsheet'
require 'open-uri'

task :import_appointments => :environment do
	errors = []
	appointments_book = Spreadsheet.open './lib/tasks/data_import/appointment_list.xls'

	relevant_sheets = appointments_book.worksheets.select { |sheet| sheet.name.match(/(October|November|December) \d{1,2}/) }
	# relevant_sheets = appointments_book.worksheets.select { |sheet| sheet.name.match(/November 7/) }
	relevant_sheets.each do |current_sheet|
		current_timeslot = nil
		current_sheet.each_with_index do |line, ix|
			next if ix < 4
			next if !line.any?

			begin
				if time = line[0]
					start = time.split("-").first
					start[0] = (start[0].to_i + 12).to_s if start.split(":").first.to_i < 10
					datetime = DateTime.parse(current_sheet.name + " #{start}")

					# daylight savings ^__________^
					if Rails.env == "development"
						if datetime > Date.new(2018, 10, 28)
							datetime -= 2.hours
						else
							datetime -= 3.hours
						end
					end
					current_timeslot =  datetime
					puts "start time: #{current_timeslot}"
				end

				time, membership_number, name, family_count, attending, notes = line

				next unless current_timeslot
				next unless membership_number

				if membership = Membership.find_by(number: membership_number)
					attending = 2 if attending.nil? || attending.to_i < 1
					appointment = Appointment.create(
						datetime: current_timeslot.to_datetime,
						people_count: attending,
						membership_id: membership.id,
						notes: notes)

					puts "created appointment for membership #{membership.number} at #{current_timeslot} "
				else
					raise "couldn't find membership_number #{membership_number} : #{line}"
				end
			rescue => e
				errors << e.message
				puts e
			end
		end
	end
	puts "#{errors.count} errors"
	puts errors
end