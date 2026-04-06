class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit ]
  before_action :set_user, only: %i[ index show new edit ]

  def index
    # 先把查询结果加载成数组，避免视图里 count/size 对带 search_rank
    # 自定义 select 的 relation 再次触发 PostgreSQL 计数 SQL。
    @items = Item.search(search_params).to_a
    @autocomplete_suggestions = if params[:keyword].present?
      Item.autocomplete(params[:keyword], limit: 8)
    else
      Item.where.not(name: [ nil, "" ]).distinct.order(:name).limit(8).pluck(:name)
    end
    @seller_locations = Item.available_seller_locations
  end

  def autocomplete
    suggestions = Item.autocomplete(params[:q])

    render json: suggestions
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    new_item_params = item_params()
    name = new_item_params[:seller_name]
    new_item_params.delete(:seller_name)

    @item = Item.new(new_item_params)
    @item.post_date = Date.current
    @item.seller_id = User.find_seller_id(name)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully posted!" }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def item_params
      params.require(:item).permit(:name, :category, :description, :price, :seller_name, :photo)
    end

    def search_params
      params.permit(:keyword, :category, :status, :seller_location, :min_price, :max_price, :posted_within_days, :sort)
    end
end
