class CreatePitchTypes < ActiveRecord::Migration
  def change
    create_table :pitch_types do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :pitch_types, :name, unique: true
  end
end
