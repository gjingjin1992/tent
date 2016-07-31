# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Site types
[
  'Farm',
  'Touring Park',
  'Garden'
].each do |name|
  SiteType.create!(name: name)
end

# Pitch types
[
  'Tent Rental',
  'Yurt',
  'Pod',
  'Caravan Pitch',
  'Caravan for Hire',
  'Motorhome/Touring Van Pitch'
].each do |name|
  PitchType.create!(name: name)
end

# Amenities
[
  'WiFi',
  'Shower',
  'Shop',
  'Toilet Block',
  'Car Park'
].each do |name|
  Amenity.create!(name: name)
end
