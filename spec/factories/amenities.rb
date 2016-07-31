FactoryGirl.define do
  factory :amenity do
    
    sequence :name do |n|
      "amenity#{n}"
    end
  end
end
