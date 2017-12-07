require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let!(:user) {User.create(email: 'example@example.com', password: 'password')}

  let!(:calculation_name) {CalculationName.create(calculation_name: 'test_calculation', user_id: user.id, id: 1)}

  let!(:saved_weekly_calculation) do
    SavedWeeklyCalculation.create(
        year_and_week: Date.today,
        predicted_rate: 1.0,
        sum: 1.0,
        profit_loss: 1.0,
        rank: 1,
        user_id: user.id,
        calculation_name_id: calculation_name.id
    )
  end

  describe 'GET #index' do
    before :each do
      sign_in(user)
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'loads all of the calc names into @calculation_name' do
      get :index
      expect(assigns(:calculation_names)).to eq(calculation_name)
    end

    it 'assigns @saved_weekly_calculations' do
      get :index
      expect(assigns(:saved_weekly_calculations)).to eq(saved_weekly_calculation)
    end
  end

  describe 'DELETE destroy' do
    before :each do
      sign_in(user)
    end

    it 'deletes saved weekly calculation' do
      delete :destroy, params: {id: saved_weekly_calculation.id}
      expect(SavedWeeklyCalculation.where(id: saved_weekly_calculation.id).count).to eq(0)
    end

    it 'deletes calculation name' do
      delete :destroy, params: {id: calculation_name.id}
      expect(CalculationName.where(id: calculation_name.id).count).to eq(0)
    end
  end

  describe 'POST create' do
    before :each do
      sign_in(user)
      allow(controller).to receive(:current_user) {user}
    end
    context 'with valid attributes' do
      it 'creates a new calculation name' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 1'}
        end.to change(CalculationName, :count).by(1)
      end

      it 'creates 20 new saved weekly calculations' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 2'}
        end.to change(SavedWeeklyCalculation, :count).by(20)
      end

      it 'creates 50 new historical weekly rates' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 2'}
        end.to change(HistoricalWeeklyRate, :count).by(50)
      end

      it 'creates 1 new current weekly rate' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 2'}
        end.to change(CurrentWeeklyRate, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'prevents creating historical weekly rates do to missing base currency' do
        expect do
          post :create, params: {:"base-currency" => '',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 2'}
        end.to raise_error(NoMethodError)
      end

      it 'prevents creating historical weekly rates do to missing target currency' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => '',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 2'}
        end.to raise_error(NoMethodError)
      end

      it 'prevents creating a calculation name with an already existing name' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'test_calculation'}
        end.to raise_exception(ActiveRecord::RecordInvalid)
      end

      it 'prevents creating a calculation name without a name' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => ''}
        end.to raise_exception(ActiveRecord::RecordInvalid)
      end

      it 'prevents creating saved weekly rates without a max waiting time' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => 1000,
                                 :"max-waiting-time" => '',
                                 :"calculation-name" => 'calc name 2'}
        end.to raise_exception(NoMethodError)
      end

      it 'prevents creating saved weekly rates without an amount' do
        expect do
          post :create, params: {:"base-currency" => 'EUR',
                                 :"target-currency" => 'USD',
                                 :amount => '',
                                 :"max-waiting-time" => 20,
                                 :"calculation-name" => 'calc name 2'}
        end.to raise_exception(NoMethodError)
      end
    end
  end
end
