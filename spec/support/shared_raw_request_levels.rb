RSpec.shared_context "shared raw request levels", shared_context: :metadata do
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
end
