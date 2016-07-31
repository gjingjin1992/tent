FactoryGirl.define do
  factory :pitch do
    site
    association :type, factory: :pitch_type

    sequence :name do |n|
      "Pitch #{n}"
    end

    max_persons 6
    length 10.0
    width  15.0
  end
end
