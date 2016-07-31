class CreateSiteTypes < ActiveRecord::Migration
  def change
    create_table :site_types do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :site_types, :name, unique: true
  end
end
