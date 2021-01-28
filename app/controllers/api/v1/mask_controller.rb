class Api::V1::MaskController < ApplicationController
    def index
        pharmack_store = PharmackStore.new
        pharmack_store.name = 'tt'
        pharmack_store.cashBalance = 10.20
        pharmack_store.
        pharmack_store.save
    end
    def create
        
    end
end
