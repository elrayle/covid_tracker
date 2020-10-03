RSpec.shared_context "shared raw results", shared_context: :metadata do
  let(:raw_request_upto_country) do
    {
      date: "2020-05-31",
      country_iso: "USA"
    }
  end

  let(:raw_request_upto_state) do
    {
      date: "2020-05-31",
      country_iso: "USA",
      province_state: "New York"
    }
  end

  let(:raw_request_upto_county) do
    {
      date: "2020-05-31",
      country_iso: "USA",
      province_state: "New York",
      admin2_county: "Broome"
    }
  end

  let(:raw_result_without_error) do
    {
      id: "2020-05-31_usa-new_york-cortland",
      label: "Cortland, New York, USA (2020-05-31)",
      region_code: "usa-new_york-cortland",
      region_label: "Cortland, New York, USA",
      date: "2020-05-31",
      cumulative_confirmed: 203,
      delta_confirmed: 3,
      cumulative_deaths: 5,
      delta_deaths: 0
    }
  end

  let(:raw_result_with_error) do
    {
      error: 'No data on 2020-05-30 for country_iso: USA, province_state: Alabama, admin2_county: Butler'
    }
  end

  let(:raw_datum_without_error) do
    {
      result: raw_result_without_error,
      request: raw_request_upto_county
    }
  end

  let(:raw_datum_with_error) do
    {
      result: raw_result_with_error,
      request: raw_request_upto_county
    }
  end
end
