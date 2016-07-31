class CreateSiteImages < ActiveRecord::Migration
  def change
    create_table :site_images do |t|
      t.references :site, index: true, foreign_key: true
      t.attachment :content

      t.timestamps null: false
    end
  end
end
