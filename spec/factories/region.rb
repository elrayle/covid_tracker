FactoryBot.define do
  factory :region, class: CovidTracker::Region do
    region_code { 'usa-texas' }
  end
end
