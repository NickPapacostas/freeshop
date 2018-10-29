class Size < ApplicationRecord
	validates_uniqueness_of :name

	def self.standard_sizes
		@sizes ||= ["Mens", "Womens", "Boy", "Girl", "Baby"].map {|name| Size.where(name: name).first_or_create }
	end

	def self.toiletry_sizes
		["Soap", "Shampoo", "Shower Gel", "Lotion", "Misc"].map {|name| Size.where(name: name).first_or_create}
	end

	def self.bag_sizes
		["Small", "Large", "Back Pack"].map {|name| Size.where(name: name).first_or_create}
	end

	def self.adult_child_sizes
		["Child", "Adult"].map {|name| Size.where(name: name).first_or_create}
	end

	def self.seasonal_sizes
		["Winter", "Summer"].map {|name| Size.where(name: name).first_or_create}
	end

	def self.household_item_sizes
		["Blanket", "Sheet", "Misc"].map {|name| Size.where(name: name).first_or_create}
	end
end