require 'fixer_api'
require 'date'
require 'http'
class DashboardController < ApplicationController
  include FixerApi
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  def index
    if params[:id].present?
      @saved_weekly_calculations = SavedWeeklyCalculation
                                   .where(calculation_name_id: params[:id])
      respond_to do |format|
        format.html
        format.json do
          render json: { saved_weekly_calculations: @saved_weekly_calculations }
        end
      end
    else
      @calculations = CalculationName.where(user_id: current_user.id)
      respond_to do |format|
        format.html
        format.json do
          render json: { calculations: @calculations }
        end
      end
    end
  end

  def destroy
    @saved_weekly_calculations = SavedWeeklyCalculation
                                 .where(calculation_name_id: params[:id])
    @saved_weekly_calculations.destroy_all

    @calculation_name = CalculationName.find(params[:id])
    @calculation_name.destroy

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @today_date = Date.today
    @base_currency = params[:"base-currency"].upcase
    @target_currency = params[:"target-currency"].upcase
    @calculation_name = params[:"calculation-name"]
    @max_waiting_time = params[:"max-waiting-time"].to_i
    @amount = params[:amount]
    @saved_weekly_calculations_array = []

    if HistoricalWeeklyRate.where(base: @base_currency).blank?
      0.upto(24) do |weekly_index|
        first_thread = Thread.new do
          weekly_date = (@today_date - ((weekly_index * 7) + 364))
          weekly_returned_rates = HTTP.get("https://api.fixer.io/#{weekly_date}?base=#{@base_currency}").parse
          insert_historical_weekly_rates(
            @base_currency,
            weekly_date,
            weekly_returned_rates
          )
        end
        second_thread = Thread.new do
          weekly_date = (@today_date - ((weekly_index * 7) + 729))
          weekly_returned_rates = HTTP.get("https://api.fixer.io/#{weekly_date}?base=#{@base_currency}").parse
          insert_historical_weekly_rates(
            @base_currency,
            weekly_date,
            weekly_returned_rates
          )
        end
        first_thread.join
        second_thread.join
      end
    end
    if CurrentWeeklyRate.where(base: @base_currency).blank?
      current_base_rate = HTTP.get("https://api.fixer.io/#{@today_date}?base=#{@base_currency}").parse
      insert_current_weekly_rate(
        @base_currency,
        @today_date,
        current_base_rate
      )
    end

    CalculationName.create!(
      calculation_name: @calculation_name,
      user_id: current_user.id
    )
    @calculation_name_id = CalculationName
                           .where(calculation_name: @calculation_name).first.id
    @current_target_rate = CurrentWeeklyRate
                           .where(base: @base_currency).first[@target_currency.to_sym]

    1.upto(@max_waiting_time) do |index|
      first_week = @today_date - ((index * 7) + 364)
      second_week = @today_date - ((index * 7) + 729)
      first_year_rate = HistoricalWeeklyRate.where(base: @base_currency)
                                             .where(week: first_week)
                                             .first[@target_currency.to_sym]
      second_year_rate = HistoricalWeeklyRate.where(base: @base_currency)
                                             .where(week: second_week)
                                             .first[@target_currency.to_sym]
      predicted_rate = (first_year_rate + second_year_rate) / 2
      sum = (@amount.to_i * predicted_rate).to_f
      profit_loss = ((@amount.to_f * predicted_rate.to_f) - (@amount.to_f * @current_target_rate.to_f))
      year_and_week = @today_date + (index * 7)
      saved_weekly_calculation_hash = {
        year_and_week: year_and_week,
        predicted_rate: predicted_rate,
        sum: sum,
        profit_loss: profit_loss,
        calculation_name_id: @calculation_name_id,
        user_id: current_user.id
      }
      @saved_weekly_calculations_array << saved_weekly_calculation_hash
    end

    top_three = @saved_weekly_calculations_array.sort_by { |hsh| hsh[:sum] }.reverse.first(3)
    top_three_ranked = top_three.each.with_index(1) { |hsh, index| hsh[:rank] = index }
    @saved_weekly_calculations_array.collect do |saved_calc_hsh|
      top_three_ranked.any? do |top_three_hash|
        if top_three_hash[:year_and_week] == saved_calc_hsh[:year_and_week]
          saved_calc_hsh[:rank] = top_three_hash[:rank]
        end
      end
    end

    @saved_weekly_calculations_array.each do |hsh|
      SavedWeeklyCalculation.create(
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