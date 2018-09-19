require 'rake'

task :populate_items => :environment do
  sizes = ["Mens", "Womens", "Boy", "Girl"]
  sizes.each {|size| Size.create(name: size)}
  puts "Created #{Size.count} sizes"


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
  	"Household Items"
  ]

  item_types.each {|item_type| ItemType.create(name: item_type)}
  puts "Created #{ItemType.count} item types"

  ItemType.all.each do |item_type|
  	Size.all.each do |size|
  		Item.create(item_type_id: item_type.id, size_id: size.id)
  	end
  end

  puts "created #{Item.count} items"

end