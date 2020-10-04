RSpec.shared_context "shared raw request in region 1", shared_context: :metadata do
  include_context "shared raw request dates"
  include_context "shared region registration 1"

  let(:raw_request_region_1_day_1) do
    {
      date: raw_request_date_1,
      country_iso: country_iso_label_region_1,
      province_state: province_state_label_region_1,
      admin2_county: admin2_county_label_region_1
    }
  end

  let(:raw_request_region_1_day_2) do
    {
      date: raw_request_date_2,
      country_iso: country_iso_label_region_1,
      province_state: province_state_label_region_1,
      admin2_county: admin2_county_label_region_1
    }
  end
end
