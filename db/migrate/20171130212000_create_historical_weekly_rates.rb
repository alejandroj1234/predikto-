class CreateHistoricalWeeklyRates < ActiveRecord::Migration[5.1]
  def change
    create_table :historical_weekly_rates do |t|

      t.string  :base, null: false
      t.date    :week, null: false
      t.integer :week_number, null: false
      t.decimal :AUD, precision: 8, scale: 3
      t.decimal :BGN, precision: 8, scale: 3
      t.decimal :BRL, precision: 8, scale: 3
      t.decimal :CAD, precision: 8, scale: 3
      t.decimal :CHF, precision: 8, scale: 3
      t.decimal :CNY, precision: 8, scale: 3
      t.decimal :CZK, precision: 8, scale: 3
      t.decimal :DKK, precision: 8, scale: 3
      t.decimal :EUR, precision: 8, scale: 3
      t.decimal :GBP, precision: 8, scale: 3
      t.decimal :HKD, precision: 8, scale: 3
      t.decimal :HRK, precision: 8, scale: 3
      t.decimal :HUF, precision: 8, scale: 3
      t.decimal :IDR, precision: 8, scale: 3
      t.decimal :ILS, precision: 8, scale: 3
      t.decimal :INR, precision: 8, scale: 3
      t.decimal :JPY, precision: 8, scale: 3
      t.decimal :KRW, precision: 8, scale: 3
      t.decimal :MXN, precision: 8, scale: 3
      t.decimal :MYR, precision: 8, scale: 3
      t.decimal :NOK, precision: 8, scale: 3
      t.decimal :NZD, precision: 8, scale: 3
      t.decimal :PHP, precision: 8, scale: 3
      t.decimal :PLN, precision: 8, scale: 3
      t.decimal :RON, precision: 8, scale: 3
      t.decimal :RUB, precision: 8, scale: 3
      t.decimal :SEK, precision: 8, scale: 3
      t.decimal :SGD, precision: 8, scale: 3
      t.decimal :THB, precision: 8, scale: 3
      t.decimal :TRY, precision: 8, scale: 3
      t.decimal :USD, precision: 8, scale: 3
      t.decimal :ZAR, precision: 8, scale: 3

      t.timestamps
    end
  end
end
