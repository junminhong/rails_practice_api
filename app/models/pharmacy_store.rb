class PharmacyStore < ApplicationRecord
    has_many :pharmacy_store_open_times
    has_many :pharmacy_store_masks
end
