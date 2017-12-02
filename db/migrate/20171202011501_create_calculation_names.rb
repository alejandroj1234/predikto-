class CreateCalculationNames < ActiveRecord::Migration[5.1]
  def change
    create_table :calculation_names do |t|
      t.string  :calculation_name      , null: false
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
    add_index :calculation_names, :calculation_name, unique: true
  end
end
