FactoryGirl.define do
  factory :pitch_type do
    sequence :name do |n|
      "Pitch type #{n}"
    end
  end
end
