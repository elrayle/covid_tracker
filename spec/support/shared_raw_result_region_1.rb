RSpec.shared_context "shared raw result region 1", shared_context: :metadata do
  include_context "shared raw request dates"
  include_context "shared region registration 1"

  let(:raw_result_region_1_day_1_id) { "#{raw_request_date_1}_#{region_1_code}" }
  let(:raw_result_region_1_day_1_label) { "#{region_1_label} (#{raw_request_date_1})" }
  let(:raw_result_region_1_day_1_cum_confirmed) { 402 }
  let(:raw_result_region_1_day_1_delta_confirmed) { 6 }
  let(:raw_result_region_1_day_1_cum_deaths) { 17 }
  let(:raw_result_region_1_day_1_delta_deaths) { 1 }

  let(:raw_result_region_1_day_1) do
    {
      id: raw_result_region_1_day_1_id,
      label: raw_result_region_1_day_1_label,
      region_code: region_1_code,
      region_label: region_1_label,
      date: raw_request_date_1,
      cumulative_confirmed: raw_result_region_1_day_1_cum_confirmed,
      delta_confirmed: raw_result_region_1_day_1_delta_confirmed,
      cumulative_deaths: raw_result_region_1_day_1_cum_deaths,
      delta_deaths: raw_result_region_1_day_1_delta_deaths
    }
  end

  let(:raw_result_region_1_day_2_id) { "#{raw_request_date_2}_#{region_1_code}" }
  let(:raw_result_region_1_day_2_label) { "#{region_1_label} (#{raw_request_date_2})" }
  let(:raw_result_region_1_day_2_cum_confirmed) { 411 }
  let(:raw_result_region_1_day_2_delta_confirmed) { 9 }
  let(:raw_result_region_1_day_2_cum_deaths) { 18 }
  let(:raw_result_region_1_day_2_delta_deaths) { 1 }

  let(:raw_result_region_1_day_2) do
    {
      id: "#{raw_request_date_2}_#{region_1_code}",
      label: "#{region_1_label} #{raw_request_date_2}",
      region_code: region_1_code,
      region_label: region_1_label,
      date: raw_request_date_2,
      cumulative_confirmed: raw_result_region_1_day_2_cum_confirmed,
      delta_confirmed: raw_result_region_1_day_2_delta_confirmed,
      cumulative_deaths: raw_result_region_1_day_2_cum_deaths,
      delta_deaths: raw_result_region_1_day_2_delta_deaths
    }
  end

  let(:raw_result_region_1_day_1_with_error) do
    {
      error: "No data on #{raw_request_date_1} for " \
             "country_iso: #{country_iso_label_region_1}, " \
             "province_state: #{province_state_label_region_1}, " \
             "admin2_county: #{admin2_county_label_region_1}"
    }
  end
end
