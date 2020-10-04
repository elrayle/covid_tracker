RSpec.shared_context "shared raw results for 2 regions", shared_context: :metadata do
  include_context "shared raw results in region 1"
  include_context "shared raw results in region 2"

  let(:raw_results_for_2_regions) do
    {
      region_registration_1.code => raw_results_region_1,
      region_registration_2.code => raw_results_region_2
    }
  end
end
