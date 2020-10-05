FactoryBot.define do
  factory :region_count, class: CovidTracker::RegionCount do
    association :region, factory: :region
    result_code { '2020-03-01-FAKE-REGION' }
    result_label { 'Region, Fake (2020-03-01)' }
    date { "2020-03-01" }

    transient do
      counts { [5, 4, 3, 2] }
    end

    after(:build) do |region_count, evaluator|
      region_count.cumulative_confirmed = evaluator.counts[0]
      region_count.delta_confirmed = evaluator.counts[1]
      region_count.cumulative_deaths = evaluator.counts[2]
      region_count.delta_deaths = evaluator.counts[3]
    end
  end
end
