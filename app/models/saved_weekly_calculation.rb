class SavedWeeklyCalculation < ApplicationRecord
  belongs_to :calculation_name
  validates_presence_of :year_and_week
  validates_presence_of :predicted_rate
  validates_presence_of :sum
  validates_presence_of :profit_loss
  validates_presence_of :profit_loss
end
