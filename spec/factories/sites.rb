FactoryGirl.define do
  factory :site do
    owner
    association :type, factory: :site_type
    sequence :name do |n|
      "Site #{n}"
    end

    sequence :email do |n|
      "site#{n}@example.com"
    end

    sequence :address1 do |n|
      "Orange Ln #{n}"
    end

    country   'United Kingdom'
    county    'Cornwall'
    city      'St Ives'
    town      'St Ives'
    postcode  'TR26 2DS'
    telephone '0905 252 2250'
    longitude 5.48075
    latitude  50.211434

    general_desc   'Great camping site!'
    detailed_desc  'Great camping site on the seashore!'
    arrival_time   '10:00:00'
    departure_time '12:00:00'
  end
end
