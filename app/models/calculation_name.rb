class CalculationName < ApplicationRecord
  belongs_to :user
  has_many :saved_weekly_calculations
  validates :calculation_name, presence: true, uniqueness: true
end
