class CreateSiteAmenities < ActiveRecord::Migration
  def change
    create_table :site_amenities do |t|
      t.references :site, index: true, foreign_key: true
      t.references :amenity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
