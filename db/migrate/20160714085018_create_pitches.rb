class CreatePitches < ActiveRecord::Migration
  def change
    create_table :pitches do |t|
      t.references :site, index: true, foreign_key: true
      t.references :pitch_type, index: true, foreign_key: true
      t.string :name
      t.integer :max_persons
      t.float :length
      t.float :width

      t.timestamps null: false
    end
    add_index :pitches, :max_persons
  end
end
