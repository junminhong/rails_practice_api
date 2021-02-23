class Api::V1::SearchController < ApplicationController
  def index
    show_result if params[:choose] && params[:name] && params[:sort]
  end
  private
  def show_result
    show_pharmacy_by_like if params[:choose] == 0
    show_mask_by_like if params[:choose] == 1
  end

  def show_pharmacy_by_like
    name = params[:name]
    Pharmacy.where("name like ?", name)
  end

  def show_mask_by_like

  end
end
