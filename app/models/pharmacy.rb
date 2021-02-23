class Pharmacy < ApplicationRecord
  has_many :pharmacy_open_times
  has_many :pharmacy_masks
end
