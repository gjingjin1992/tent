FactoryGirl.define do
  factory :site_image do
    site
    # content { File.new("#{Rails.root}/spec/support/fixtures/test-image.jpg") }
  end
end
