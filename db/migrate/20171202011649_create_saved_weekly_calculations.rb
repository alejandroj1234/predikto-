class CreateSavedWeeklyCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_weekly_calculations do |t|

      t.date   :year_and_week   , null: false
      t.float  :predicted_rate  , null: false
      t.float  :sum             , null: false
      t.float  :profit_loss     , null: false
      t.float  :rank            , null: true
      t.references :user, index: true, foreign_key: true
      t.references :calculation_name, index: true, foreign_key: true
      t.timestamps
    end
  end
end