class CalculationName < ApplicationRecord
  validates :calculation_name, presence: true, uniqueness: true
  has_many :saved_weekly_calculations
end
