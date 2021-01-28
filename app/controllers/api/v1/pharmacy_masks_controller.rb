class Api::V1::PharmacyMasksController < ApplicationController
    def index
        show_all_pharmacy_masks if params[:choose] && params[:sort] && params[:pharmacy_store_id]
        show_all_mask_count_price if params[:date]
    end

private
    def show_all_pharmacy_masks
        sort_pharmacy_masks_by_asc if params[:sort].upcase == 'ASC'
        sort_pharmacy_masks_by_desc if params[:sort].upcase == 'DESC'
    end
    def show_all_mask_count_price

    end
    def remove_created_and_updated_time_cols(result_data)
        new_result_data = Array.new
        result_data.as_json.map do |result|
            new_result_data.push(result.except("created_at", "updated_at"))
        end
        new_result_data
    end
    def sort_pharmacy_masks_by_asc
        sort_label = params[:choose] == "0" ? "pharmacy_store_masks.pharmacy_mask_name ASC" : "pharmacy_store_masks.pharmacy_mask_price ASC"
        pharmacy_store_mask = PharmacyStoreMask.where("pharmacy_store_id=?", params[:pharmacy_store_id]).order(sort_label)
        all_pharmacy_store_masks = remove_created_and_updated_time_cols(pharmacy_store_mask)
        render json: all_pharmacy_store_masks
    end
    def sort_pharmacy_masks_by_desc
        sort_label = params[:choose] == "0" ? "pharmacy_store_masks.pharmacy_mask_name DESC" : "pharmacy_store_masks.pharmacy_mask_price DESC"
        pharmacy_store_mask = PharmacyStoreMask.where("pharmacy_store_id=?", params[:pharmacy_store_id]).order(sort_label)
        all_pharmacy_store_masks = remove_created_and_updated_time_cols(pharmacy_store_mask)
        render json: all_pharmacy_store_masks
    end
end
