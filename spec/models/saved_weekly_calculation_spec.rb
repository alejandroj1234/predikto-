require 'rails_helper'

RSpec.describe SavedWeeklyCalculation, type: :model do

  let(:user) { User.create(email: 'user@example.com', password: 'password', id: 1) }
  let(:calculation_name) { CalculationName.create(calculation_name: 'test_calculation', user_id: user.id, id: 1) }

  subject {
    described_class.new(year_and_week: 2016 - 11 - 26,
                        predicted_rate: 1.00,
                        sum: 2.00,
                        profit_loss: 3.0,
                        rank: 1,
                        user_id: user.id,
                        calculation_name_id: calculation_name.id)
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a year and week" do
      subject.year_and_week = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a predicted rate" do
      subject.predicted_rate = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a sum" do
      subject.sum = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a profit_loss" do
      subject.profit_loss = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a rank" do
      subject.rank = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a user id" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a calculation name id" do
      subject.calculation_name_id = nil
      expect(subject).to_not be_valid
    end
  end
end