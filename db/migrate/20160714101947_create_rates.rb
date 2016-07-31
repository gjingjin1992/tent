class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :pitch, index: true, foreign_key: true
      t.date :from_date
      t.date :to_date
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps null: false
    end
    add_index :rates, :from_date
    add_index :rates, :to_date
    add_index :rates, :amount
  end
end
