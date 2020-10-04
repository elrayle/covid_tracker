RSpec.shared_context "shared raw datum in region 2", shared_context: :metadata do
  include_context "shared raw result region 2"
  include_context "shared raw request in region 2"

  let(:datum_for_region_2_day_1) do
    CovidTracker::RegionDatum.for(raw_datum_region_2_day_1)
  end

  let(:raw_datum_region_2_day_1) do
    {
      result: raw_result_region_2_day_1,
      request: raw_request_region_2_day_1
    }
  end

  let(:raw_datum_region_2_day_1_with_error) do
    {
      result: raw_result_region_2_day_1_with_error,
      request: raw_request_region_2_day_1
    }
  end

  let(:datum_for_region_2_day_2) do
    CovidTracker::RegionDatum.for(raw_datum_region_2_day_1)
  end

  let(:raw_datum_region_2_day_2) do
    {
      result: raw_result_region_2_day_2,
      request: raw_request_region_2_day_2
    }
  end

  let(:raw_datum_region_2_day_2_with_error) do
    {
      result: raw_result_region_2_day_2_with_error,
      request: raw_request_region_2_day_2
    }
  end
end
