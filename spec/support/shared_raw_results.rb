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
      province_state: "Alabama"
    }
  end

  let(:raw_request_upto_county) do
    {
      date: "2020-05-31",
      country_iso: "USA",
      province_state: "Alabama",
      admin2_county: "Butler"
    }
  end

  let(:raw_result_without_error) do
    {
      id: "2020-05-31_usa-alabama-butler",
      label: "Butler, Alabama, USA (2020-05-31)",
      region_code: "alabama-butler",
      region_label: "Butler, Alabama, USA",
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

  let(:raw_result_2) do
    {
      id: "2020-06-01_usa-alabama-butler",
      label: "Butler, Alabama, USA (2020-06-01)",
      region_code: "alabama-butler",
      region_label: "Butler, Alabama, USA",
      date: "2020-06-01",
      cumulative_confirmed: 207,
      delta_confirmed: 4,
      cumulative_deaths: 6,
      delta_deaths: 1
    }
  end

  let(:raw_datum_2) do
    {
      result: raw_result_2,
      request: raw_request_upto_county
    }
  end
end
