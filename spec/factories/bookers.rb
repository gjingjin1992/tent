FactoryGirl.define do
  factory :booker do

    sequence :email do |n|
      "booker#{n}@example.com"
    end

    password 'supersecret'
    password_confirmation 'supersecret'

    sequence :first_name do |n|
      "John#{n}"
    end

    sequence :last_name do |n|
      "Doe#{n}"
    end

    sequence :address do |n|
      "Main st #{n}"
    end

    sequence :telephone do |n|
      "111-111#{n}"
    end
  end
end
