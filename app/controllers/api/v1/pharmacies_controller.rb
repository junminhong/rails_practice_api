require 'net/http'
require 'active_record'
require 'activerecord-import'
class Api::V1::PharmaciesController < ApplicationController
  before_action :process_params
  def index

  end

  def create
    pharmacy = Pharmacy.first
    unless pharmacy
      process_pharmacy
      render json: {message: 'create data complete', data: {}}
    else
      render json: {message: 'haven data', data: {}}
    end
  end

  private
  def process_params
    show_open_time if params[:datetime]
    show_open_week if params[:week]
    show_range_price if params[:money] && params[:choose]
  end

  def init_data_tmp
    @open_week_ary = Array.new
    @open_time_ary = Array.new
    @open_time_decide_count = 0
  end

  def convert_number_to_week
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
    return new_result_data
  end

  def show_open_time
    time_fmt = Time.at(params[:datetime].to_time).strftime("%H:%M:%S")
    result_data = PharmacyOpenTime.where("open_time <= ? AND close_time >= ?", time_fmt.to_s, time_fmt.to_s)
    pharmacies = remove_created_and_updated_time_cols(result_data)
    render json: pharmacies and return
  end

  def show_open_week
    week =  convert_number_to_week
    result_data = PharmacyOpenTime.where("week=?", week.to_s)
    pharmacies = remove_created_and_updated_time_cols(result_data)
    render json: pharmacies
  end

  def show_range_price
    case params[:choose]
    when 0
      pharmacy_masks = PharmacyMask.where("price >= ?", params[:money]).select(:pharmacy_id).distinct
    when 1
      pharmacy_masks = PharmacyMask.where("price <= ?", params[:money]).select(:pharmacy_id).distinct
    end
    pharmacy_id_ary = Array.new
    pharmacy_masks.as_json.map do |pharmacy_mask|
      pharmacy_id_ary.push(pharmacy_mask["pharmacy_id"])
    end
    all_pharmacy_tmp = Pharmacy.where(id: pharmacy_id_ary)
    all_pharmacy = remove_created_and_updated_time_cols(all_pharmacy_tmp, false)
    render json: all_pharmacy.as_json and return
  end

  def fetch_pharmacy_json
    pharmacies_json_url = "https://raw.githubusercontent.com/kdan-mobile-software-ltd/phantom_mask/master/data/pharmacies.json"
    pharmacies_json = Net::HTTP.get(URI(pharmacies_json_url))
    return JSON.parse(pharmacies_json)
  end

  def process_pharmacy
    pharmacies_json = fetch_pharmacy_json
    pharmacies_json.map do |pharmacies_value|
      pharmacy = Pharmacy.create(
        name: pharmacies_value["name"].to_s,
        cash_balance: pharmacies_value["cashBalance"].to_f
      )
      pharmacy.pharmacy_open_times = process_open_time(pharmacies_value["openingHours"])
      pharmacies_value["masks"].map do |mask|
        pharmacy_mask = PharmacyMask.new(
          name: mask["name"],
          price: mask["price"],
          )
        pharmacy.pharmacy_masks << pharmacy_mask
      end
    end
  end

  def process_open_time(opening_hours)
    pharmacy_open_times = Array.new
    open_time_ary = Array.new
    open_week_ary = Array.new
    flag = false
    opening_hours.scan(/\w+/).map do |open_time|
      if open_time.match(/\d+/).blank?
        if flag
          pharmacy_open_times = insert_open_time(open_week_ary, open_time_ary, pharmacy_open_times)
          open_time_ary = Array.new
          open_week_ary = Array.new
          flag = false
        end
        open_week_ary.push(open_time)
      end
      unless open_time.match(/\d+/).blank?
        open_time_ary.push(open_time)
        flag = true
      end
    end
    return pharmacy_open_times
  end

  def insert_open_time(open_week_ary, open_time_ary, pharmacy_open_times)
    open_time = "#{open_time_ary[0]}:#{open_time_ary[1]}"
    close_time = "#{open_time_ary[2]}:#{open_time_ary[3]}"
    open_week_ary.map do |open_week|
      pharmacy_open_times << PharmacyOpenTime.new(
        week: open_week,
        open_time: open_time,
        close_time: close_time
      )
    end
    return pharmacy_open_times
  end
end