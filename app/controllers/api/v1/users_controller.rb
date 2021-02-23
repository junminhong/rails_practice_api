require 'net/http'
class Api::V1::UsersController < ApplicationController
  def index
    show_mask_total_count_price if params[:date]
  end
  def create
    user = User.first
    unless user
      create_user_all_info
      render json: {msg: 'create data complete'}
    else
      render json: {msg: 'haven data'}
    end
  end
  private
  def show_mask_total_count_price

  end
  def create_user_all_info
    users_json_url = "https://raw.githubusercontent.com/kdan-mobile-software-ltd/phantom_mask/master/data/users.json"
    users_json = Net::HTTP.get(URI(users_json_url))
    users_json = JSON.parse(users_json)
    users_json.map do |users_value|
      user = User.new(
        name: users_value["name"].to_s,
        cash_balance: users_value["cashBalance"].to_f
      )
      user.save
      users_value["purchaseHistories"].map do |purchase_history|
        user_purchase_history = UserPurchaseHistory.new(
          pharmacy_name: purchase_history["pharmacyName"].to_s,
          mask_name: purchase_history["maskName"].to_s,
          transaction_amount: purchase_history["transactionAmount"].to_f,
          transaction_date: purchase_history["transactionDate"]
        )
        user.user_purchase_histories << user_purchase_history
      end
    end
  end
end
