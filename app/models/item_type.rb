class ItemType < ApplicationRecord
	validates_uniqueness_of :name

  def sizes
    Item.where(item_type: self).map(&:size).uniq
  end
end