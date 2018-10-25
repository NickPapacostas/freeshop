require 'test_helper'

class MemberImporterTest < ActiveSupport::TestCase
	test "name parsing: 'first last'" do
		importer = MemberImporter.new
 		initial_name = "Jane Doe"
 		assert ["Jane", "Doe"] == importer.parse_name(initial_name)
	end

	test "name parsing: 'first'" do
		importer = MemberImporter.new
 		initial_name = "Jane"
 		assert ["Jane", ""] == importer.parse_name(initial_name)
	end

	test "name parsing: 'ID' and not 'hamid'" do
		importer = MemberImporter.new
		real_name = "Hamid"
 		id_name = "    ID   "

 		assert ["Hamid", ""] == importer.parse_name(real_name)
 		assert [nil, nil] == importer.parse_name(id_name)
	end

	test "birth year parsing" do
		importer = MemberImporter.new
		types_of_dates = ["10 years old", "age 10", "2008", "11/11/2008"]
		types_of_dates.each do |date|
			binding.pry if importer.parse_birth_year(date) != 2008
			assert 2008 == importer.parse_birth_year(date)
		end
	end
end