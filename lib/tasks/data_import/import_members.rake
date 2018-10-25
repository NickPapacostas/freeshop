require 'rake'
require 'spreadsheet'
require 'open-uri'

task :import_members => :environment do
	MemberImporter.new.import
end