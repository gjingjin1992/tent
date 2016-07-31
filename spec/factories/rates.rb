FactoryGirl.define do
  factory :rate do
    pitch

    sequence :from_date do |n|
      "2016-#{(n % 12) + 1}-01"
    end

    sequence :to_date do |n|
      "2016-#{(n % 12) + 1}-28"
    end

    amount "20.00"
  end
end
