RSpec.shared_context "shared raw results in region 2", shared_context: :metadata do
  include_context "shared region registration 2"
  include_context "shared raw datum in region 2"

  let(:raw_results_region_2) do
    CovidTracker::RegionResults.new(region_registration: region_registration_2,
                                    region_data: region_2_data)
  end

  let(:region_2_data) do
    [datum_for_region_2_day_1, datum_for_region_2_day_2]
  end
end
