FactoryGirl.define do
  factory :site_type do
    sequence :name do |n|
      "Site type #{n}"
    end
  end
end
