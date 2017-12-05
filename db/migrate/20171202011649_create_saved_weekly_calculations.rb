class CreateSavedWeeklyCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_weekly_calculations do |t|

      t.date    :year_and_week   , null: false
      t.decimal :predicted_rate  , precision: 20, scale: 3, null: false
      t.decimal :sum             , precision: 20, scale: 3, null: false
      t.decimal :profit_loss     , precision: 20, scale: 3, null: false
      t.integer :rank            , null: true
      t.references :user, index: true, foreign_key: true
      t.references :calculation_name, index: true, foreign_key: true
      t.timestamps
    end
  end
end