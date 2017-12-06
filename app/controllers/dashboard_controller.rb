require 'fixer_api'
require 'date'
require 'http'
class DashboardController < ApplicationController
  include FixerApi
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  def index
    # If a calculation name ID is passed in the parameters then get
    # all associated saved weekly calculations
    # else get all calculation names associated with the current user
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
    # Calculation name id is passed in as a parameter.
    # The respective calculation name and all the associated
    # saved weekly calculations are destroyed
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

    # check if the base currency passed in from the form has a historical rate created within the past week
    # if it isn't then check if the base currency even has a historical rate,
    # if it does then figure out how many weeks it has been since the most recent rate has been created
    # Get a count for the weeks between the most recently created and today's date
    # Then Delete the earlier historical rates
    # Then enter in the db for each one year ago and two years ago, the rates for the respective date 

    if HistoricalWeeklyRate.where(base: @base_currency)
                           .where(created_at: @today_date.weeks_ago(1).end_of_day..@today_date.end_of_day).blank?

      if HistoricalWeeklyRate.where(base: @base_currency).present?
        most_recent_created_at_date = HistoricalWeeklyRate.where(base: @base_currency)
                                                          .order(:created_at)
                                                          .reverse.first
                                                          .created_at.to_date
        @week_count = most_recent_created_at_date.step(@today_date, 7).count - 1
        @week_count.each do |count|
          HistoricalWeeklyRate.where(base: @base_currency)
                              .order(:week)[count].destroy
          HistoricalWeeklyRate.where(base: @base_currency)
                              .order(:week)[count + 25].destroy
        end
      end

      total_number_of_weeks = @week_count.present? ? @week_count : 25
      1.upto(total_number_of_weeks) do |weekly_index|
        first_thread = Thread.new do
          date_of_week = (@today_date.years_ago(1) + (weekly_index * 7))
          week_number = (@today_date.years_ago(1) + (weekly_index * 7)).cweek + 100
          attempt_count = 0
          max_attempts = 10
          begin
            attempt_count += 1
            weekly_returned_rates = HTTP.get("https://api.fixer.io/#{date_of_week}?base=#{@base_currency}").parse
          rescue
            sleep 3
            retry if attempt_count < max_attempts
          end
          insert_historical_weekly_rates(
            @base_currency,
            date_of_week,
            week_number,
            weekly_returned_rates
          )
        end
        second_thread = Thread.new do
          date_of_week = (@today_date.years_ago(2) + (weekly_index * 7))
          week_number = (@today_date.years_ago(2) + (weekly_index * 7)).cweek + 200
          attempt_count = 0
          max_attempts = 10
          begin
            attempt_count += 1
            weekly_returned_rates = HTTP.get("https://api.fixer.io/#{date_of_week}?base=#{@base_currency}").parse
          rescue
            sleep 3
            retry if attempt_count < max_attempts
          end
          insert_historical_weekly_rates(
            @base_currency,
            date_of_week,
            week_number,
            weekly_returned_rates
          )
        end
        first_thread.join
        second_thread.join
      end
    end

    # The same logic as for historical values but for the current rate
    if CurrentWeeklyRate.where(base: @base_currency)
                        .where(created_at: @today_date.weeks_ago(1).end_of_day..@today_date.end_of_day).blank?
      CurrentWeeklyRate.where(base: @base_currency).destroy_all
      attempt_count = 0
      max_attempts = 10
      begin
        attempt_count += 1
        current_base_rate = HTTP.get("https://api.fixer.io/#{@today_date}?base=#{@base_currency}").parse
      rescue
        sleep 3
        retry if attempt_count < max_attempts
      end
      insert_current_weekly_rate(
        @base_currency,
        @today_date.beginning_of_week,
        current_base_rate
      )
    end

    # Need to create a calculation name in the db for the calculation and set values
    # Checks if the calculation name is already taken
    # Need to also set the current rate for the target rate 
    @stored_calculation_name = CalculationName.new(
      calculation_name: @calculation_name,
      user_id: current_user.id
    )
    respond_to do |format|
      format.html
      if @stored_calculation_name.save
        render plain: { error: 'none' }.to_json, content_type: 'application/json'
      else
        render plain: {
          error: @stored_calculation_name.errors,
          name: @stored_calculation_name.calculation_name
        }.to_json, content_type: 'application/json'
      end
    end
    @current_target_rate = CurrentWeeklyRate.where(base: @base_currency)
                                            .first[@target_currency.to_sym]

    # For each week the user wants a calculation
    # get the first and second year historical rates,
    # then divide by two to get the average historical rate for that week.
    # This value is the predicated rate.
    # using the predicated rate calculate sum and profit/loss and push into array
    1.upto(@max_waiting_time) do |index|
      first_week_number = (@today_date.years_ago(1) + (index * 7)).cweek + 100
      second_week_number = (@today_date.years_ago(2) + (index * 7)).cweek + 200

      first_year_rate = HistoricalWeeklyRate.where(base: @base_currency)
                                            .where(week_number: first_week_number)
                                            .first[@target_currency.to_sym]
      second_year_rate = HistoricalWeeklyRate.where(base: @base_currency)
                                             .where(week_number: second_week_number)
                                             .first[@target_currency.to_sym]
      predicted_rate = (first_year_rate + second_year_rate) / 2
      sum = (@amount * predicted_rate)
      profit_loss = ((@amount * predicted_rate) - (@amount * @current_target_rate))
      year_and_week = (@today_date + (index * 7))
      saved_weekly_calculation_hash = {
        year_and_week: year_and_week,
        predicted_rate: predicted_rate,
        sum: sum,
        profit_loss: profit_loss,
        calculation_name_id: @stored_calculation_name.id,
        user_id: current_user.id
      }
      @saved_weekly_calculations_array << saved_weekly_calculation_hash
    end

    # Find the top three weekly calculations by sum, rank each one,
    # and push into weekly calculations array
    top_three = @saved_weekly_calculations_array.sort_by { |hsh| hsh[:sum] }.reverse.first(3)
    top_three_ranked = top_three.each.with_index(1) { |hsh, index| hsh[:rank] = index }
    @saved_weekly_calculations_array.collect do |saved_calc_hsh|
      top_three_ranked.any? do |top_three_hash|
        if top_three_hash[:year_and_week] == saved_calc_hsh[:year_and_week]
          saved_calc_hsh[:rank] = top_three_hash[:rank]
        end
      end
    end

    # save each weekly calculation in the DB
    @saved_weekly_calculations_array.each do |hsh|
      SavedWeeklyCalculation.create(
        year_and_week: hsh[:year_and_week],
        predicted_rate: hsh[:predicted_rate],
        sum: hsh[:sum],
        profit_loss: hsh[:profit_loss],
        rank: hsh[:rank],
        calculation_name_id: @stored_calculation_name.id,
        user_id: current_user.id
      )
    end
  end
end