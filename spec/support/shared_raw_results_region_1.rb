RSpec.shared_context "shared raw results in region 1", shared_context: :metadata do
  include_context "shared region registration 1"
  include_context "shared raw datum in region 1"

  let(:raw_results_region_1) do
    CovidTracker::RegionResults.new(region_registration: region_registration_1,
                                    region_data: region_1_data)
  end

  let(:region_1_data) do
    [CovidTracker::RegionDatum.for(raw_datum_region_1_day_1),
     CovidTracker::RegionDatum.for(raw_datum_region_1_day_2)]
  end
end
