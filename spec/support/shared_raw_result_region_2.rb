RSpec.shared_context "shared raw result region 2", shared_context: :metadata do
  include_context "shared raw request dates"
  include_context "shared region registration 2"

  let(:raw_result_region_2_day_1_id) { "#{raw_request_date_1}_#{region_2_code}" }
  let(:raw_result_region_2_day_1_label) { "#{region_2_label} (#{raw_request_date_1})" }
  let(:raw_result_region_2_day_1_cum_confirmed) { 144 }
  let(:raw_result_region_2_day_1_delta_confirmed) { 3 }
  let(:raw_result_region_2_day_1_cum_deaths) { 7 }
  let(:raw_result_region_2_day_1_delta_deaths) { 0 }

  let(:raw_result_region_2_day_1) do
    {
      id: raw_result_region_2_day_1_id,
      label: raw_result_region_2_day_1_label,
      region_code: region_2_code,
      region_label: region_2_label,
      date: raw_request_date_1,
      cumulative_confirmed: raw_result_region_2_day_1_cum_confirmed,
      delta_confirmed: raw_result_region_2_day_1_delta_confirmed,
      cumulative_deaths: raw_result_region_2_day_1_cum_deaths,
      delta_deaths: raw_result_region_2_day_1_delta_deaths
    }
  end

  let(:raw_result_region_2_day_2_id) { "#{raw_request_date_2}_#{region_2_code}" }
  let(:raw_result_region_2_day_2_label) { "#{region_2_label} (#{raw_request_date_2})" }
  let(:raw_result_region_2_day_2_cum_confirmed) { 148 }
  let(:raw_result_region_2_day_2_delta_confirmed) { 4 }
  let(:raw_result_region_2_day_2_cum_deaths) { 7 }
  let(:raw_result_region_2_day_2_delta_deaths) { 0 }

  let(:raw_result_region_2_day_2) do
    {
      id: raw_result_region_2_day_2_id,
      label: raw_result_region_2_day_2_label,
      region_code: region_2_code,
      region_label: region_2_label,
      date: raw_request_date_2,
      cumulative_confirmed: raw_result_region_2_day_2_cum_confirmed,
      delta_confirmed: raw_result_region_2_day_2_delta_confirmed,
      cumulative_deaths: raw_result_region_2_day_2_cum_deaths,
      delta_deaths: raw_result_region_2_day_2_delta_deaths
    }
  end

  let(:raw_result_region_2_day_1_with_error) do
    {
      error: "No data on #{raw_request_date_1} for " \
             "country_iso: #{country_iso_label_region_2}, " \
             "province_state: #{province_state_label_region_2}, " \
             "admin2_county: #{admin2_county_label_region_2}"
    }
  end
end
