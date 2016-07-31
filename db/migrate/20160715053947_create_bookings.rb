class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :booker, index: true, foreign_key: true
      t.references :pitch,  index: true, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
    add_index :bookings, :start_date
    add_index :bookings, :end_date
    add_index :bookings, [:pitch_id, :start_date, :end_date], order: { end_date: :desc }
  end
end
