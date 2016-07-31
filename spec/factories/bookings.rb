FactoryGirl.define do
  factory :booking do
    booker
    pitch

    sequence :start_date do |n|
      "2016-#{(n % 12) + 1}-01"
    end

    sequence :end_date do |n|
      "2016-#{(n % 12) + 1}-28"
    end
  end
end
