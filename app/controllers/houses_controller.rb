class HousesController < ApplicationController

  include Concerns::HouseSearchConcern
  before_filter :set_search_params

  def index
    search_for_houses @search_params
  end

  def show
    @house_order ||= HouseOrder.new order_params
    @house ||= decorate_house params[:id]
  end

  def create
    @house_order = HouseOrder.new order_params

    if @house_order.save
      NotificationService.new.new_order(@house_order)
      redirect_to order_path(@house_order)
    else
      @house = decorate_house @house_order.house_id
      render 'show'
    end
  end

  private

  def order_params
    params.fetch(:house_order, {}).permit!
  end

  def decorate_house id
    House.find(id).decorate
  end

  def set_search_params
    @search_params = {}

    if houses_view_mode == 'table'
      @search_params = {show: 30}
    end
  end

end
