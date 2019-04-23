require 'rake'

task :populate_items => :environment do
  item_types = [
  	"Shirts",
  	"Trousers",
  	"Shorts",
  	"Sweaters",
  	"Jackets",
  	"Shoes",
  	"Underwear",
  	"Pajamas",
  	"Socks",
  	"Dresses",
  	"Skirts",
  	"Leggings & Tights",
  	"Onesies",
  	"Toiletries",
  	"Bags",
  	"Gloves",
  	"Hat",
  	"Belt",
  	"Scarves",
  	"Household Items",
    "Toys"
  ]

  item_types.each {|item_type| ItemType.create(name: item_type)}
  puts "Created #{ItemType.count} item types"

  ItemType.all.each do |item_type|
  	if item_type.name == "Toiletries"
      sizes = Size.toiletry_sizes
    elsif item_type.name == "Bags"
      sizes = Size.bag_sizes
    elsif ["Gloves", "Hat", "Belt"].include? item_type.name
      sizes = Size.adult_child_sizes
    elsif item_type.name == "Scarves"
      sizes = Size.seasonal_sizes
    elsif item_type.name == "Household Items"
      sizes = Size.household_item_sizes
    elsif item_type.name == "Toys"
      sizes = Size.toy_sizes
    else
      sizes = Size.standard_sizes
    end

    sizes.each do |size|
      Item.create(item_type_id: item_type.id, size_id: size.id)
    end
  end

  puts "created #{Item.count} items"

end