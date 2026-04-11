class FavoritesController < ApplicationController
  before_action :require_login

  def index
    @favorite_items = current_user.favorite_items
  end

  def create
    @item = Item.find(params[:item_id])
    current_user.favorites.find_or_create_by(item: @item)
    redirect_to @item, notice: "Added to favorites successfully!"
  end

  def destroy
    favorite = current_user.favorites.find_by(item_id: params[:id])
    favorite&.destroy
    redirect_to request.referer || items_path, notice: "Removed from favorites successfully!"
  end
end