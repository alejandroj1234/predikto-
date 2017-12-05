require "rails_helper"

RSpec.describe DashboardController, :type => :controller do

  let!(:user) { User.create(email: "example@example.com", password: "password") }

  let(:calculation_name) { CalculationName.create(calculation_name: 'test_calculation', user_id: user.id, id: 1) }


  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      sign_in(user)
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "does correct redirect" do
      get :index
      expect(response).to redirect_to new_user_session_path
    end

    it "loads all of the calc names into @calc_names" do
      sign_in(user)
      get :index
      expect(assigns(:calculation_names)).to eq(calculation_name

                                             )
    end
  end
end