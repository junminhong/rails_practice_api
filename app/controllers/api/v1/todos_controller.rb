require 'net/http'
class Api::V1::TodosController < ApplicationController
    def index
        #todos = Todo.all
        pharmacies_json_url = "https://raw.githubusercontent.com/kdan-mobile-software-ltd/phantom_mask/master/data/pharmacies.json"
        pharmacies_json = Net::HTTP.get(URI(pharmacies_json_url))
        pharmacies_json = JSON.parse(pharmacies_json)
        openingHours_split_ary = Array.new
        pharmacies_json.map {|openingHours| openingHours_split_ary.push(openingHours["openingHours"].scan(/\w+/))}
        openingHours_split_ary.map do |openingHours_split_ary| 
            openingHours_split_ary.map do |openingHours_split|
                if openingHours_split.match(/\d+/) == nil
                    puts "星期 #{openingHours_split}"
                elsif
                    puts openingHours_split
                end
            end
        end
        puts "#{openingHours_split_ary}"
        render json: pharmacies_json
    end
    def show
        index = params[:index]
        todo = Todo.find(index)
        render json: todo
    end
    def create
        index = params[:index]
        todo = Todo.find(index)
        byebug
        puts todo
        render json: todo?
    end
end
