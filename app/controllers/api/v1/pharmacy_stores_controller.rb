require 'net/http'
class Api::V1::PharmacyStoresController < ApplicationController
    def index
        show_open_time_pharmacy_stores if params[:datetime]
        show_open_week_pharmacy_stores if params[:week]
        show_range_price_pharmacy_stores if params[:money] && params[:choose]
    end
    def create
        pharmacy_store = PharmacyStore.first
        unless pharmacy_store 
            create_pharmacy_all_info
            render json: {msg: 'create data complete'}
        else
            render json: {msg: 'haven data'}
        end
    end
    private
    def init_data_tmp
        @open_week_ary = Array.new
        @open_time_ary = Array.new
        @open_time_decide_count = 0
    end
    def convert_week_number_to_week
        case params[:week].to_i
            when 1
                'Mon'
            when 2
                'Tue'
            when 3
                'Wed'
            when 4
                'Thu'
            when 5
                'Fri'
            when 6
                'Sat'
            when 7
                'Sun'
        end
    end
    def remove_created_and_updated_time_cols(result_data, none_time_flag = true )
        new_result_data = Array.new
        result_data.as_json.map do |result|
            result["open_time"] = Time.at(result["open_time"].to_time).strftime("%H:%M:%S") if none_time_flag
            result["close_time"] = Time.at(result["close_time"].to_time).strftime("%H:%M:%S") if none_time_flag
            new_result_data.push(result.except("created_at", "updated_at"))
        end
        new_result_data
    end
    def show_open_time_pharmacy_stores
        time_fmt = Time.at(params[:datetime].to_time).strftime("%H:%M:%S")
        result_data = PharmacyStoreOpenTime.where("open_time <= ? AND close_time >= ?", time_fmt.to_s, time_fmt.to_s)
        all_pharmacy_stores = remove_created_and_updated_time_cols(result_data)
        render json: all_pharmacy_stores
    end
    def show_open_week_pharmacy_stores
        week =  convert_week_number_to_week
        result_data = PharmacyStoreOpenTime.where("week=?", week.to_s)
        all_pharmacy_stores = remove_created_and_updated_time_cols(result_data)
        render json: all_pharmacy_stores
    end
    def show_range_price_pharmacy_stores
        case params[:choose]
            when "0"
                all_pharmacy_masks = PharmacyStoreMask.where("pharmacy_mask_price >= ?", params[:money]).select(:pharmacy_store_id).distinct
            when "1"
                all_pharmacy_masks = PharmacyStoreMask.where("pharmacy_mask_price <= ?", params[:money]).select(:pharmacy_store_id).distinct
        end
        pharmacy_store_id_ary = Array.new
        all_pharmacy_masks.as_json.map do |pharmacy_mask|
            pharmacy_store_id_ary.push(pharmacy_mask["pharmacy_store_id"])
        end
        all_pharmacy_stores_tmp = PharmacyStore.where(id: pharmacy_store_id_ary)
        all_pharmacy_stores = remove_created_and_updated_time_cols(all_pharmacy_stores_tmp, false)
        render json: all_pharmacy_stores.as_json
    end
    def create_pharmacy_all_info
        pharmacies_json_url = "https://raw.githubusercontent.com/kdan-mobile-software-ltd/phantom_mask/master/data/pharmacies.json"
        pharmacies_json = Net::HTTP.get(URI(pharmacies_json_url))
        pharmacies_json = JSON.parse(pharmacies_json)
        pharmacies_json.map do |pharmacies_value|
            openingHours_split_ary = pharmacies_value["openingHours"].scan(/\w+/)
            open_time = ''
            init_data_tmp
            pharmacy_store = PharmacyStore.new(
                name: pharmacies_value["name"].to_s,
                cash_balance: pharmacies_value["cashBalance"].to_f
            )
            pharmacy_store.save
            # 可再優化
            openingHours_split_ary.map do |openingHours_split_value_ary|
                if openingHours_split_value_ary.match(/\d+/) == nil
                    @open_week_ary.push(openingHours_split_value_ary)
                    open_time = ''
                elsif
                    if open_time == ''
                        open_time = openingHours_split_value_ary
                    elsif
                        open_time += ':' + openingHours_split_value_ary
                        @open_time_ary.push(open_time)
                        @open_time_decide_count += 1
                        open_time = ''
                    end
                end
                if @open_time_decide_count == 2
                    @open_week_ary.map do |open_week|
                        pharmacy_store_open_time = PharmacyStoreOpenTime.new(
                            week: open_week, 
                            open_time: @open_time_ary[0],
                            close_time: @open_time_ary[1]
                        )
                        pharmacy_store_open_time.save
                        pharmacy_store.pharmacy_store_open_times << pharmacy_store_open_time
                    end
                    init_data_tmp
                end
            end
            pharmacies_value["masks"].map do |mask|
                pharmacy_store_mask = PharmacyStoreMask.new(
                    pharmacy_mask_name: mask["name"], 
                    pharmacy_mask_price: mask["price"],
                )
                pharmacy_store_mask.save
                pharmacy_store.pharmacy_store_masks << pharmacy_store_mask
            end
        end
    end
end
