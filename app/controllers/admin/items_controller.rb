class Admin::ItemsController < ApplicationController
  def index
    redirect_to volunteer_dashboard_path(current_volunteer) unless current_volunteer.admin

    @items = Item.all
  end

  def create
    item_type_name = params[:item_type_name]
    sizes = params[:sizes].reject(&:empty?)

    if item_type_name.empty? || ItemType.find_by(name: item_type_name)
      flash[:error] = "Failed to create item: name blank or already exists"
    else
      create_new_items(item_type_name, sizes)
      flash[:success] = "Item #{item_type_name} created!"
    end

    redirect_to admin_items_path
  end

  private

  def create_new_items(item_type_name, sizes)
    item_type = ItemType.create(name: item_type_name)

    Size.where(name: sizes).each do |size|
      Item.create(item_type: item_type, size: size)
    end
  end

end