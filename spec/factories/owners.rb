FactoryGirl.define do
  factory :owner do

    sequence :name do |n|
      "owner#{n}"
    end

    sequence :email do |n|
      "owner#{n}@example.com"
    end

    password 'supersecret'
    password_confirmation 'supersecret'

    sequence :address1 do |n|
      "Orange Ln #{n}"
    end

    country 'United Kingdom'
    county 'Cornwall'
    city 'St Ives'
    town 'St Ives'
    postcode 'TR26 2DS'
    telephone '0905 252 2250'
  end
end
