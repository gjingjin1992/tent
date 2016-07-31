class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :owner,     index: true, foreign_key: true
      t.references :site_type, index: true, foreign_key: true
      t.string :name,          null: false
      t.string :address1,      null: false
      t.string :address2,      null: true
      t.string :address3,      null: true
      t.string :country,       null: false, default: 'United Kingdom'
      t.string :county,        null: false
      t.string :city,          null: false
      t.string :town,          null: false
      t.string :postcode,      null: false
      t.string :telephone,     null: false
      t.string :email,         null: false
      t.st_point :coordinates, null: false, geographic: true, srid: 4326
      t.string :general_desc,  null: false
      t.string :detailed_desc, null: false
      t.time :arrival_time,    null: false
      t.time :departure_time,  null: false
      t.attachment :main_image

      t.timestamps null: false
    end

    add_index :sites, :coordinates, using: :gist
    add_index :sites, [:name, :owner_id], unique: true

  end
end
