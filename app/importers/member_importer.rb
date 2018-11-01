require 'spreadsheet'

class MemberImporter
	attr_accessor :errors

	def initialize
		@errors = []
		@members = []
		@memberships = []
	end

	def import(spreadheet_file_path = './lib/tasks/data_import/membership_list.xls')
		members_book = Spreadsheet.open spreadheet_file_path

		relevant_sheets = find_relevant_sheets(members_book.worksheets)

		relevant_sheets.each do |sheet|
			process_sheet(sheet)
		end

		Membership.all.each do |m|
			if m.members.first
				m.point_of_contact_id = m.members.first.id
				m.save
			end
		end
	end

	def process_sheet(sheet)
		current_membership_number = nil
		sheet.each_with_index do |line, ix|
			next if ix == 0
			next if !line.any?
			begin
				number, size, initial_name = line
				initial_birth = line[3]
				if number
					current_membership_number = number
				else
					number = current_membership_number
				end

				first_name, last_name = parse_name(initial_name)
				membership = find_or_build_membership(number)
				member = find_or_build_member(first_name, last_name, membership, initial_birth)

				membership.members << member
				membership.skip_point_of_contact = true

				if membership.save
					member.update_attribute(membership_id: membership.id)
					@memberships << membership
					@members << member
				else
					@errors << {
						member: member,
						membership: membership,
						first_name: first_name,
						last_name: last_name,
						initial_name: initial_name
					}
				end
			rescue => e
				@errors << e
			end
		end
	end


	def find_or_build_membership(number)
		Membership.find_by(number: number) || Membership.new(number: number)
	end

	def parse_name(initial_name)
		return [nil, nil] if initial_name.nil? || initial_name.strip.match(/^ID$/)
		name = initial_name.to_s.strip

		first_name, nothing, last_name = name.rpartition(' ')

		if first_name.empty? && !last_name.nil?
			first_name = last_name
			last_name = ""
		end

		[first_name, last_name]
	end

	def find_or_build_member(first_name, last_name, membership, initial_birth)
		existing_member = Member.find_by(
			first_name: first_name,
			last_name: last_name,
			membership_id: membership.id)

		return existing_member if existing_member

		birth_year = parse_birth_year(initial_birth)

		Member.new(
			first_name: first_name,
			last_name: last_name,
			birth_year: birth_year)

	end

	def parse_birth_year(initial_birth)
		return nil unless initial_birth
		return initial_birth.year if initial_birth.is_a?(Date)
		date = initial_birth.to_s
		if date.match("age") || date.match(/years old/i)
			# "age 28 years old"
			age = date.match(/\d{1,2}/).to_s.to_i
			Date.today.year - age
		elsif year = date.match(/\d{4}/)
			# "2018"
			year.to_s.to_i
		elsif date_match = date.match(/\d+\/\d+\/(\d{2,4})/)
			# "10/11/2005" || "10/11/05"
			date_format = date_match[1].length == 2 ? "%d/%m/%y" : "%d/%m/%Y"
			Date.strptime(date, date_format).year
		end
	end

	private

	def find_relevant_sheets(worksheets = [])
		return [] if worksheets.empty?
		number_range_pattern = /(\d+.+\d+)/ # e.g. "1-99", "1000-1999"
		worksheets.select { |worksheet| worksheet.name.match number_range_pattern }
	end

end