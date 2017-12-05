require 'rails_helper'

RSpec.describe CalculationName, type: :model do

  let(:user) { User.create(email: 'user@example.com', password: 'password', id: 1) }

  subject { described_class.new(calculation_name: "test_calculation", user_id: user.id) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a calculation name" do
      subject.calculation_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a user id" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
  end
end