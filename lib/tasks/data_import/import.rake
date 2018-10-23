require 'rake'
require 'spreadsheet'
require 'open-uri'

task :import_members => :environment do
	errors = []
	# if membership_list_url = ENV["MEMBERSHIP_LIST_URL"]
	# 	response = open(membership_list_url).read
	# 	binding.pry
	# 	File.write('lib/tasks/data_import/membership_list.xls', 'w')
	# 	members_book = Spreadsheet.open 'lib/tasks/data_import/membership_list.xls'
	# else
	# 	members_book = Spreadsheet.open 'lib/tasks/data_import/membership_list.xls'
	# end

	members_book = Spreadsheet.open './lib/tasks/data_import/membership_list.xls'

	# get sheets with names like "1-99", "1000-1099"
	relevant_sheets = members_book.worksheets.select { |sheet| sheet.name.match(/\d+-\d+/) || sheet.name.match(/\d+_\d+/) }

	relevant_sheets.each do |current_sheet|
		current_membership_number = nil

		current_sheet.each_with_index do |line, ix|
			begin
				next if ix == 0
				next if !line.any?
				number, size, name, birth = line

				if number == nil
					membership = Membership.find_by(number: current_membership_number)
				else
					current_membership_number = number
					if membership = Membership.find_by(number: number)
						membership
					else
						puts "createing membership #{number}"
						membership = Membership.new(number: number)
					end
				end


				if name
					name = name.strip
					first_name, nothing, last_name = name.rpartition(' ')
				else
					raise "no name for row: #{ix + 1} in sheet #{current_sheet.name}: #{line}"
				end

				unless Member.find_by(first_name: first_name, last_name: last_name, membership_id: membership.id)
					birth = birth.to_s
					if birth
						birth_year =
						if birth.match("age") || birth.match(/years old/i)
								# "age 28 years old"
								age = birth.match(/\d{1,2}/).to_s.to_i
								Date.today.year - age
							elsif year = birth.match(/\d{4}/)
								# "2018"
								year.to_s.to_i
							elsif birth.match(/\d+\/\d+\/(\d{2,4})/)
								# "10/11/2005"
								Date.strptime(birth, "%m/%d/%Y").year
							end
						else
							birth_year = nil
						end

						member = Member.new(
							first_name: first_name,
							last_name: last_name,
							birth_year: birth_year)

						membership.members << member
					end

					membership.skip_point_of_contact = true

					membership.save!
					puts "created member #{member.full_name} for membership #{membership.number}"
				end
			rescue => e
			# binding.pry if e.message.match("undefined method")
			unless e.message.match("name can't be blank")
				errors << "#{e} : #{line}"
				puts e
			end
		end
	end
	Membership.all.each do |m|
		if m.members.first
			m.point_of_contact_id = m.members.first.id
			m.save
		end
	end
	puts "#{errors.length} errors"
	puts "#{errors}"
end