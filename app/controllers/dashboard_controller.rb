require 'fixer_api'
require 'date'
require 'http'
class DashboardController < ApplicationController
  include FixerApi
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  def index
    if params[:id].present?
      @saved_weekly_exchanges = SavedWeeklyExchange.where(calculation_name_id: params[:id])
      respond_to do |format|
        format.html
        format.json { render json: { saved_weekly_exchanges: @saved_weekly_exchanges } }
      end
    else
      @calculations = CalculationName.where(user_id: current_user.id)
      respond_to do |format|
        format.html
        format.json { render json: { calculations: @calculations } }
      end
    end
  end

  def destroy
    @saved_weekly_exchanges = SavedWeeklyExchange.where(calculation_name_id: params[:id])
    @saved_weekly_exchanges.destroy_all

    @calculation_name = CalculationName.find(params[:id])
    @calculation_name.destroy

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @today_date = Date.today
    if HistoricalWeeklyRate.where(base: params[:"base-currency"].upcase).blank?
      0.upto(24) do |index|
        t = Thread.new do
          first_api_call_date = (@today_date - ((index * 7) + 364))
          first_weekly_returned_rates = HTTP.get("https://api.fixer.io/#{first_api_call_date}?base=#{params[:"base-currency"].upcase}").parse
          HistoricalWeeklyRate.create(
            base: params[:"base-currency"].upcase,
            week: first_api_call_date,
            AUD: first_weekly_returned_rates["rates"]["AUD"],
            BGN: first_weekly_returned_rates["rates"]["BGN"],
            BRL: first_weekly_returned_rates["rates"]["BRL"],
            CAD: first_weekly_returned_rates["rates"]["CAD"],
            CHF: first_weekly_returned_rates["rates"]["CHF"],
            CNY: first_weekly_returned_rates["rates"]["CNY"],
            CZK: first_weekly_returned_rates["rates"]["CZK"],
            DKK: first_weekly_returned_rates["rates"]["DKK"],
            EUR: first_weekly_returned_rates["rates"]["EUR"],
            GBP: first_weekly_returned_rates["rates"]["GBP"],
            HKD: first_weekly_returned_rates["rates"]["HKD"],
            HRK: first_weekly_returned_rates["rates"]["HRK"],
            HUF: first_weekly_returned_rates["rates"]["HUF"],
            IDR: first_weekly_returned_rates["rates"]["IDR"],
            ILS: first_weekly_returned_rates["rates"]["ILS"],
            INR: first_weekly_returned_rates["rates"]["INR"],
            JPY: first_weekly_returned_rates["rates"]["JPY"],
            KRW: first_weekly_returned_rates["rates"]["KRW"],
            MXN: first_weekly_returned_rates["rates"]["MXN"],
            MYR: first_weekly_returned_rates["rates"]["MYR"],
            NOK: first_weekly_returned_rates["rates"]["NOK"],
            NZD: first_weekly_returned_rates["rates"]["NZD"],
            PHP: first_weekly_returned_rates["rates"]["PHP"],
            PLN: first_weekly_returned_rates["rates"]["PLN"],
            RON: first_weekly_returned_rates["rates"]["RON"],
            RUB: first_weekly_returned_rates["rates"]["RUB"],
            SEK: first_weekly_returned_rates["rates"]["SEK"],
            SGD: first_weekly_returned_rates["rates"]["SGD"],
            THB: first_weekly_returned_rates["rates"]["THB"],
            TRY: first_weekly_returned_rates["rates"]["TRY"],
            USD: first_weekly_returned_rates["rates"]["USD"],
            ZAR: first_weekly_returned_rates["rates"]["ZAR"])
        end

        s = Thread.new do
          second_api_call_date = (@today_date - ((index * 7) + 729))
          second_weekly_returned_rates = HTTP.get("https://api.fixer.io/#{second_api_call_date}?base=#{params[:"base-currency"].upcase}").parse
          HistoricalWeeklyRate.create(
            base: params[:"base-currency"].upcase,
            week: second_api_call_date,
            AUD: second_weekly_returned_rates["rates"]["AUD"],
            BGN: second_weekly_returned_rates["rates"]["BGN"],
            BRL: second_weekly_returned_rates["rates"]["BRL"],
            CAD: second_weekly_returned_rates["rates"]["CAD"],
            CHF: second_weekly_returned_rates["rates"]["CHF"],
            CNY: second_weekly_returned_rates["rates"]["CNY"],
            CZK: second_weekly_returned_rates["rates"]["CZK"],
            DKK: second_weekly_returned_rates["rates"]["DKK"],
            EUR: second_weekly_returned_rates["rates"]["EUR"],
            GBP: second_weekly_returned_rates["rates"]["GBP"],
            HKD: second_weekly_returned_rates["rates"]["HKD"],
            HRK: second_weekly_returned_rates["rates"]["HRK"],
            HUF: second_weekly_returned_rates["rates"]["HUF"],
            IDR: second_weekly_returned_rates["rates"]["IDR"],
            ILS: second_weekly_returned_rates["rates"]["ILS"],
            INR: second_weekly_returned_rates["rates"]["INR"],
            JPY: second_weekly_returned_rates["rates"]["JPY"],
            KRW: second_weekly_returned_rates["rates"]["KRW"],
            MXN: second_weekly_returned_rates["rates"]["MXN"],
            MYR: second_weekly_returned_rates["rates"]["MYR"],
            NOK: second_weekly_returned_rates["rates"]["NOK"],
            NZD: second_weekly_returned_rates["rates"]["NZD"],
            PHP: second_weekly_returned_rates["rates"]["PHP"],
            PLN: second_weekly_returned_rates["rates"]["PLN"],
            RON: second_weekly_returned_rates["rates"]["RON"],
            RUB: second_weekly_returned_rates["rates"]["RUB"],
            SEK: second_weekly_returned_rates["rates"]["SEK"],
            SGD: second_weekly_returned_rates["rates"]["SGD"],
            THB: second_weekly_returned_rates["rates"]["THB"],
            TRY: second_weekly_returned_rates["rates"]["TRY"],
            USD: second_weekly_returned_rates["rates"]["USD"],
            ZAR: second_weekly_returned_rates["rates"]["ZAR"])
        end
        t.join
        s.join
      end
      current_base_rate = HTTP.get("https://api.fixer.io/#{@today_date}?base=#{params[:"base-currency"].upcase}").parse
      CurrentWeeklyRate.create(
        base: params[:"base-currency"].upcase,
        week: current_base_rate["date"],
        AUD: current_base_rate["rates"]["AUD"],
        BGN: current_base_rate["rates"]["BGN"],
        BRL: current_base_rate["rates"]["BRL"],
        CAD: current_base_rate["rates"]["CAD"],
        CHF: current_base_rate["rates"]["CHF"],
        CNY: current_base_rate["rates"]["CNY"],
        CZK: current_base_rate["rates"]["CZK"],
        DKK: current_base_rate["rates"]["DKK"],
        EUR: current_base_rate["rates"]["EUR"],
        GBP: current_base_rate["rates"]["GBP"],
        HKD: current_base_rate["rates"]["HKD"],
        HRK: current_base_rate["rates"]["HRK"],
        HUF: current_base_rate["rates"]["HUF"],
        IDR: current_base_rate["rates"]["IDR"],
        ILS: current_base_rate["rates"]["ILS"],
        INR: current_base_rate["rates"]["INR"],
        JPY: current_base_rate["rates"]["JPY"],
        KRW: current_base_rate["rates"]["KRW"],
        MXN: current_base_rate["rates"]["MXN"],
        MYR: current_base_rate["rates"]["MYR"],
        NOK: current_base_rate["rates"]["NOK"],
        NZD: current_base_rate["rates"]["NZD"],
        PHP: current_base_rate["rates"]["PHP"],
        PLN: current_base_rate["rates"]["PLN"],
        RON: current_base_rate["rates"]["RON"],
        RUB: current_base_rate["rates"]["RUB"],
        SEK: current_base_rate["rates"]["SEK"],
        SGD: current_base_rate["rates"]["SGD"],
        THB: current_base_rate["rates"]["THB"],
        TRY: current_base_rate["rates"]["TRY"],
        USD: current_base_rate["rates"]["USD"],
        ZAR: current_base_rate["rates"]["ZAR"]
      )
    end

    CalculationName.create!(
      calculation_name: params[:"calculation-name"],
      user_id: current_user.id
    )
    @calculation_name_id = CalculationName.where(calculation_name: params[:"calculation-name"]).first.id
    @current_target_rate = CurrentWeeklyRate.where(base: params[:"base-currency"].upcase).first[params[:"target-currency"].upcase.to_sym]

    @saved_weekly_exchanges_array = []
    1.upto(params[:"max-waiting-time"].to_i) do |index|
      first_date              = @today_date - ((index * 7) + 364)
      second_date             = @today_date - ((index * 7) + 729)
      first_year_target_rate  = HistoricalWeeklyRate.where(base: params[:"base-currency"].upcase).where(week: first_date).first[params[:"target-currency"].upcase.to_sym]
      second_year_target_rate = HistoricalWeeklyRate.where(base: params[:"base-currency"].upcase).where(week: second_date).first[params[:"target-currency"].upcase.to_sym]
      predicted_rate = (first_year_target_rate + second_year_target_rate) / 2
      sum = (params[:amount].to_i * predicted_rate).to_f
      profit_loss = ((params[:amount].to_f * predicted_rate.to_f) - (params[:amount].to_f * @current_target_rate.to_f))
      year_and_week = @today_date + (index * 7)

      saved_weekly_exchanges_hash = {
        year_and_week: year_and_week,
        predicted_rate: predicted_rate,
        sum: sum,
        profit_loss: profit_loss,
        calculation_name_id: @calculation_name_id,
        user_id: current_user.id
      }
      @saved_weekly_exchanges_array << saved_weekly_exchanges_hash
    end

    top_three = @saved_weekly_exchanges_array.sort_by { |hsh| hsh[:sum] }.reverse.first(3)
    top_three_ranked = top_three.each.with_index(1) { |hsh, index| hsh[:rank] = index }

    @saved_weekly_exchanges_array.collect do |hsh|
      top_three_ranked.any? do |top_three_hash|
        if top_three_hash[:year_and_week] == hsh[:year_and_week]
          hsh[:rank] = top_three_hash[:rank]
        end
      end
    end

    @saved_weekly_exchanges_array.each do |hsh|
      SavedWeeklyExchange.create(
        year_and_week: hsh[:year_and_week],
        predicted_rate: hsh[:predicted_rate],
        sum: hsh[:sum],
        profit_loss: hsh[:profit_loss],
        rank: hsh[:rank],
        calculation_name_id: @calculation_name_id,
        user_id: current_user.id
      )
    end
  end
end